# List available recipes
default:
    just --list

# Update everything but texlive
update: update-emacs update-nixpkgs

# Update emacs
update-emacs:
    nix flake lock --update-input schmir-emacs

# Update to latest nixpkgs-unstable
update-nixpkgs:
    nix flake lock --update-input nixpkgs
    nix flake lock --update-input home-manager

# Update texlive by updating nixpkgs-stable
update-texlive:
    nix flake lock --update-input nixpkgs-stable

# Run home-manager switch
home-manager:
    #! /bin/sh
    old_gen=$(readlink -f ~/.nix-profile)
    flake=${HOME}/repos/io.github.schmir/nix
    echo "=======> " home-manager switch -L --flake ${flake}#${hn}
    home-manager switch -L --flake ${flake}
    new_gen=$(readlink -f ~/.nix-profile)
    nvd diff ${old_gen} ${new_gen}

nixos-build:
    nixos-rebuild build -L --flake .

nixos-switch: nixos-build
    sudo nixos-rebuild switch -L --flake .

nixos-test: nixos-build
    sudo nixos-rebuild test -L --flake .

nix-store-gc:
    nix-store --gc
