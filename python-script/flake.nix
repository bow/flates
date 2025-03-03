{
  description = "Python script minimal environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        nixTools = with pkgs; [alejandra deadnix statix];
        pyTools = with pkgs; [black ruff];
        python = pkgs.python313.withPackages (p: [p.mypy]);
        devPkgs = [python];
      in {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = devPkgs ++ pyTools ++ nixTools;
          };
        };
        formatter = pkgs.alejandra;
      }
    );
}
