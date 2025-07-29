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
        nixTools = with pkgs; [
          deadnix
          nixfmt-rfc-style
          statix
        ];
        devTools = with pkgs; [
          asciidoctor-with-extensions
          d2
          entr
          mermaid-cli
          plantuml
        ];
      in
      {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = devTools ++ nixTools;
          };
        };
        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
