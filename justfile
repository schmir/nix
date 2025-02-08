# List available recipes
default:
    just --list

# Update everything
update:
    nix flake update

# Update emacs
update-emacs:
    nix flake update schmir-emacs

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

nixos-dry-activate:
    sudo nixos-rebuild dry-activate -L --flake .

nix-store-gc:
    nix-store --gc
