{
  description = "AsciiDoc writing environment";

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
      in
      {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = [
              pkgs.asciidoctor-with-extensions
              pkgs.d2
              pkgs.entr
              pkgs.mermaid-cli
              pkgs.plantuml
            ];
          };
        };
        formatter = pkgs.nixfmt;
      }
    );
}
