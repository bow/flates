{
  description = "Nix flake for writing AsciiDoc";

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
        nixtools = with pkgs; [alejandra deadnix statix];
        devtools = with pkgs; [
          asciidoctor-with-extensions
          d2
          entr
          mermaid-cli
          plantuml
        ];
      in {
        devShells = {
          default = pkgs.mkShellNoCC {
            packages = devtools ++ nixtools;
          };
        };
        formatter = pkgs.alejandra;
      }
    );
}
