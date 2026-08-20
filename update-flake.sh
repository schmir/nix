#!/bin/sh
# Update the flake inputs and summarize the resulting package changes with
# `nvd diff`.

set -eu

system=$(nix eval --impure --raw --expr builtins.currentSystem)
target=".#legacyPackages.${system}.homeConfigurations.ralf.activationPackage"

# Build the home activation package before and after updating, then diff the two.
before=$(nix build --no-link --no-warn-dirty --print-out-paths "$target")

nix flake update "$@"

# Refuse to hand back an update that breaks any NixOS, darwin or home
# configuration. Without this only the home configuration above gets built, and
# a host can stay broken for months before anyone notices.
nix flake check --all-systems

after=$(nix build --no-link --no-warn-dirty --print-out-paths "$target")

nix shell nixpkgs#nvd --command nvd diff "$before" "$after"
