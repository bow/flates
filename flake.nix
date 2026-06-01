{
  description = ''
    Nix flake templates.

    Usage: `nix flake {new,init} -t github:bow/flates#<template-name> [<dir>]`
  '';

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
    let
      inherit (nixpkgs) lib;

      mkTemplate = name: {
        path = ./${name};
        inherit (import ./${name}/flake.nix) description;
      };

      isTemplateDir =
        name: type: type == "directory" && !(lib.strings.hasPrefix "." name) && name != "sandbox";

      templateDirs = lib.filterAttrs isTemplateDir (builtins.readDir ./.);

      templateNames = lib.attrNames templateDirs;
    in
    {
      templates = lib.genAttrs templateNames mkTemplate;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        nixTools = with pkgs; [
          nixfmt
          deadnix
          statix
        ];
        # Adapted from https://github.com/the-nix-way/dev-templates
        forEachDir = cmd: ''
          for dir in ${builtins.concatStringsSep " " templateNames}; do
            (
              cd "''${dir}"
              ${cmd}
            )
          done
        '';
        localTools = [
          (pkgs.writeShellApplication {
            name = "build-all";
            runtimeInputs = [ pkgs.nixfmt ];
            text = ''
              ${forEachDir ''
                echo "→ building ''${dir}"
                nix build ".#devShells.${system}.default"
              ''}
            '';
          })
          (pkgs.writeShellApplication {
            name = "check-all";
            text = forEachDir ''
              echo "→ checking ''${dir}"
              nix flake check --all-systems --no-build
            '';
          })
          (pkgs.writeShellApplication {
            name = "clean-all";
            text = forEachDir ''
              echo "→ cleaning ''${dir}"
              rm -f result
            '';
          })
          (pkgs.writeShellApplication {
            name = "format-all";
            runtimeInputs = [ pkgs.nixfmt ];
            text = ''
              shopt -s globstar

              nixfmt -- **/*.nix
            '';
          })
          (pkgs.writeShellApplication {
            name = "update-all";
            text = forEachDir ''
              echo "→ updating ''${dir}"
              nix flake update
            '';
          })
        ];
      in
      {
        devShells.default = pkgs.mkShellNoCC { packages = localTools ++ nixTools; };
        formatter = pkgs.nixfmt;
      }
    );
}
