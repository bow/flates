{
  description = "Presenterm presentation environment";

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
        presTools = [ pkgs.presenterm ];
      in
      {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = presTools ++ nixTools;
          };
        };
        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
