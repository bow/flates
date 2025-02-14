{
  description = ''
    Nix flake templates.

    Usage: `nix flake {new,init} -t github:bow/flates#<template-name> [<dir>]`
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }: let
    env = flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        nixtools = with pkgs; [alejandra deadnix statix];
      in {
        devShells.default = pkgs.mkShellNoCC {packages = nixtools;};
        formatter = pkgs.alejandra;
      }
    );
    template = name: {
      ${name} = {
        path = ./${name};
        description = (import ./${name}/flake.nix).description;
      };
    };
  in
    env
    // {
      templates =
        template "asciidoc"
        // template "default";
    };
}
