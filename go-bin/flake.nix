{
  description = "Go binary minimal environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      gomod2nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        readFileOr = path: default: with builtins; if pathExists path then (readFile path) else default;
        repoName = "github.com/bow/exe";
        tagFile = "${self}/.tag";
        revFile = "${self}/.rev";
        version = readFileOr tagFile "0.0.0";
        commit = readFileOr revFile "";
        app = gomod2nix.legacyPackages.${system}.buildGoApplication {
          src = ./.;
          pwd = ./.;
          name = "xgp";
          doCheck = false;
          CGO_ENABLED = 0;
          ldflags = [
            "-w" # do not generate debug output
            "-s" # strip symbols table
            "-X ${repoName}/internal.version=${version}"
            "-X ${repoName}/internal.gitCommit=${commit}"
          ];
        };
        nixTools = with pkgs; [
          deadnix
          nixfmt-rfc-style
          statix
        ];
        goTools = with pkgs; [
          go
          gocover-cobertura
          golangci-lint
          gomod2nix.packages.${system}.default
          gopls
          gosec
          gotestsum
          gotools
        ];
        devTools = with pkgs; [ just ];
      in
      {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = devTools ++ goTools ++ nixTools;
          };
        };
        packages = {
          default = app;
        };
        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
