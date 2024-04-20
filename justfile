# List available recipes
default:
    just --list

# Update everything but texlive
update: update-emacs update-nixpkgs

# Update emacs
update-emacs:
    nix flake update schmir-emacs

# Update to latest nixpkgs-unstable
update-nixpkgs:
    nix flake update nixpkgs
    nix flake update home-manager

# Update texlive by updating nixpkgs-stable
update-texlive:
    nix flake update nixpkgs-stable

# Run home-manager switch
home-manager:
    #! /bin/sh
    hn=$(hostname -s)
    old_gen=$(readlink -f ~/.nix-profile)
    flake=${HOME}/repos/io.github.schmir/nix
    echo "=======> " home-manager switch -L --flake ${flake}#${hn}
    home-manager switch -L --flake ${flake}#${hn}
    new_gen=$(readlink -f ~/.nix-profile)
    nvd diff ${old_gen} ${new_gen}
