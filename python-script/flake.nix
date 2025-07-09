{
  description = "Python script minimal environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-python = {
      url = "github:cachix/nixpkgs-python";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    nixpkgs-python,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        pyVersion = "3.13";
        pyTools = with pkgs; [black ruff];
        python = nixpkgs-python.packages.${system}.${pyVersion}.withPackages (p: [p.mypy]);
        devPkgs = [python];
        nixTools = with pkgs; [alejandra deadnix statix];
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
