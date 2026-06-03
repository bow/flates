{
  description = "Python script minimal environment";

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
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python314.withPackages (p: [ ]);
      in
      {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = [
              python
              pkgs.black
              pkgs.ruff
            ];
          };
        };
        formatter = pkgs.nixfmt;
      }
    );
}
