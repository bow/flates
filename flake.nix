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
    template = name: {
      ${name} = {
        path = ./${name};
        description = (import ./${name}/flake.nix).description;
      };
    };
    templates =
      template "asciidoc"
      // template "default";
  in
    {templates = templates;}
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        nixTools = with pkgs; [alejandra deadnix statix];
        # Adapted from https://github.com/the-nix-way/dev-templates
        forEachDir = cmd: ''
          for dir in ${builtins.concatStringsSep " " (builtins.attrNames templates)}; do
            (
              cd "''${dir}"
              ${cmd}
            )
          done
        '';
        localTools = [
          (pkgs.writeShellApplication {
            name = "build";
            runtimeInputs = [pkgs.alejandra];
            text = ''
              ${forEachDir ''
                echo "→ building ''${dir}"
                nix build ".#devShells.${system}.default"
              ''}
            '';
          })
          (pkgs.writeShellApplication {
            name = "check";
            text = forEachDir ''
              echo "→ checking ''${dir}"
              nix flake check --all-systems --no-build
            '';
          })
          (pkgs.writeShellApplication {
            name = "clean";
            text = forEachDir ''
              echo "→ cleaning ''${dir}"
              rm -f result
            '';
          })
          (pkgs.writeShellApplication {
            name = "format";
            runtimeInputs = [pkgs.alejandra];
            text = ''
              shopt -s globstar

              alejandra -- **/*.nix
            '';
          })
          (pkgs.writeShellApplication {
            name = "update";
            text = forEachDir ''
              echo "→ updating ''${dir}"
              nix flake update
            '';
          })
        ];
      in {
        devShells.default = pkgs.mkShellNoCC {packages = localTools ++ nixTools;};
        formatter = pkgs.alejandra;
      }
    );
}
