{
  description = "Ruby script minimal environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        gems = pkgs.bundlerEnv {
          name = "local-dev";
          gemdir = ./.;
        };
      in
      {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = [
              gems
              gems.wrappedRuby
              pkgs.bundix
            ];
          };
        };
        formatter = pkgs.nixfmt;
      }
    );
}
