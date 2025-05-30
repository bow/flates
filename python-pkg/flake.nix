{
  description = "Python package minimal environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    uv2nix,
    pyproject-nix,
    pyproject-build-systems,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        nixTools = with pkgs; [alejandra deadnix statix];
        pyTools = with pkgs; [black ruff uv];
        python = pkgs.python313; # NOTE: Keep in-sync with pyproject.toml.
        devPkgs = [python] ++ pyTools ++ nixTools ++ (with pkgs; [just pre-commit]);
        ciPkgs = [python] ++ pyTools ++ nixTools ++ (with pkgs; [just skopeo]);

        workspace = uv2nix.lib.workspace.loadWorkspace {workspaceRoot = ./.;};
        overlay = workspace.mkPyprojectOverlay {sourcePreference = "wheel";};
        pythonSet = (pkgs.callPackage pyproject-nix.build.packages {inherit python;}).overrideScope (
          nixpkgs.lib.composeManyExtensions [pyproject-build-systems.overlays.default overlay]
        );
        venvCI = pythonSet.mkVirtualEnv "pkg-env-all" workspace.deps.all;
        venvRelease = pythonSet.mkVirtualEnv "volt-env-release" workspace.deps.optionals;
        app = (pkgs.callPackages pyproject-nix.build.util {}).mkApplication {
          venv = venvRelease;
          package = pythonSet.pkg;
        };
      in {
        apps = {
          default = {
            type = "app";
            program = "${venvRelease}/bin/${app.pname}";
          };
        };
        devShells = {
          ci = pkgs.mkShellNoCC {packages = ciPkgs ++ [venvCI];};
          default = pkgs.mkShell rec {
            nativeBuildInputs = [python.pkgs.venvShellHook];
            packages = devPkgs;
            env = {
              UV_PYTHON_DOWNLOADS = "never";
              UV_PYTHON = "${venvDir}/bin/python";
            };
            venvDir = "./.venv";
            postVenvCreation = ''
              unset SOURCE_DATE_EPOCH
              uv sync --all-groups --active --locked
              . ${venvDir}/bin/activate
            '';
            postShellHook = ''
              unset SOURCE_DATE_EPOCH
              unset PYTHONPATH
            '';
          };
        };
        formatter = pkgs.alejandra;
        packages = let
          readFileOr = path: default:
            with builtins;
              if pathExists path
              then (readFile path)
              else default;
          imgTag =
            if app.version != "0.0.dev0"
            then app.version
            else "latest";
          imgAttrs = rec {
            name = "ghcr.io/bow/${app.pname}";
            tag = imgTag;
            contents = [app];
            config = {
              Entrypoint = ["/bin/${app.pname}"];
              Labels = {
                "org.opencontainers.image.revision" = readFileOr "${self}/.rev" "";
                "org.opencontainers.image.source" = "https://github.com/bow/${app.pname}";
                "org.opencontainers.image.title" = "${app.pname}";
                "org.opencontainers.image.url" = "https://${name}";
              };
            };
          };
        in {
          default = venvRelease;
          dockerArchive = pkgs.dockerTools.buildLayeredImage imgAttrs;
          dockerArchiveStreamer = pkgs.dockerTools.streamLayeredImage imgAttrs;
        };
      }
    );
}
