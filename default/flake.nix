{
  description = "Default minimum environment";

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
        devTools = [];
      in {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = devTools ++ nixTools;
          };
        };
        formatter = pkgs.alejandra;
      }
    );
}
