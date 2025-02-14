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
  in
    env
    // {
      templates = {
        default = {
          path = ./default;
          description = (import ./default/flake.nix).description;
        };
      };
    };
}
