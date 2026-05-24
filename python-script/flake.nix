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
        pyPackage = pkgs.python314;
        pyTools = with pkgs; [
          black
          ruff
        ];
        python = pyPackage.withPackages (p: [ ]);
        devPkgs = [ python ];
        nixTools = with pkgs; [
          deadnix
          nixfmt
          statix
        ];
      in
      {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = devPkgs ++ pyTools ++ nixTools;
          };
        };
        formatter = pkgs.nixfmt;
      }
    );
}
