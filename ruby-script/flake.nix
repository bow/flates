{
  description = "Ruby script minimal environment";

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
        rbTools = with pkgs; [bundix];
        gems = pkgs.bundlerEnv {
          name = "local-dev";
          gemdir = ./.;
        };
        devPkgs = [gems gems.wrappedRuby];
      in {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = devPkgs ++ rbTools ++ nixTools;
          };
        };
        formatter = pkgs.alejandra;
      }
    );
}
