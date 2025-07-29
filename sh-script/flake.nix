{
  description = "Shell script minimal environment";

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
        nixTools = with pkgs; [
          deadnix
          nixfmt-rfc-style
          statix
        ];
        shTools = [ pkgs.shellcheck ];
      in
      {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = shTools ++ nixTools;
          };
        };
        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
