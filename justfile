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

# Run nixos-rebuild build
nixos-build:
    nixos-rebuild build -L --flake .

# Run nixos-rebuild switch
nixos-switch: nixos-build
    sudo nixos-rebuild switch -L --flake .

# Run nixos-rebuild test
nixos-test: nixos-build
    sudo nixos-rebuild test -L --flake .

# Run nixos-rebuild dry-activate
nixos-dry-activate:
    sudo nixos-rebuild dry-activate -L --flake .

# Collect nix store garbage
nix-store-gc:
    nix-store --gc

# Run nix-darwin switch
nix-darwin-switch:
    nix run nix-darwin -- switch --flake .

