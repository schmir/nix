# List available recipes
default:
    just --list

# Format all nix files
fmt:
    nix fmt

# Run nix flake check, e.g. `just check --all-systems`
check *ARGS:
    nix flake check -L {{ ARGS }}

# Update everything
update:
    ./update-flake.sh
    #nix flake update

# Update emacs
update-emacs:
    ./update-flake.sh schmir-emacs
    #nix flake update schmir-emacs

# Run home-manager switch
home-manager:
    #! /bin/sh
    old_gen=$(readlink -f ~/.nix-profile)
    flake=$(pwd)
    echo "=======> " home-manager switch -L --flake ${flake}
    home-manager switch -L --flake ${flake}
    new_gen=$(readlink -f ~/.nix-profile)
    nvd diff ${old_gen} ${new_gen}

# Run nixos-rebuild build
nixos-build:
    nixos-rebuild build -L --flake .

# Run nixos-rebuild switch
nixos-switch: nixos-build
    sudo -H nixos-rebuild switch -L --flake .

# Run nixos-rebuild test
nixos-test: nixos-build
    sudo -H nixos-rebuild test -L --flake .

# Run nixos-rebuild dry-activate
nixos-dry-activate:
    sudo -H nixos-rebuild dry-activate -L --flake .

# List gc roots, excluding system profiles, memory and process roots
gc-roots:
    nix-store --gc --print-roots | egrep -v '^"?(/nix/var|/run/\w+-system|\{memory|/proc)'

# Run nix-darwin switch
nix-darwin-switch:
    sudo -H nix run nix-darwin -- switch --flake .

# Age in days after which `gc` deletes generations and direnv caches,
# e.g. `just maxage=60 gc`
maxage := "20"

# Collect garbage older than maxage
gc:
    # drop nix-direnv dev shell caches unused for {{ maxage }}d (rebuilt on next cd)
    find ~/.cache/direnv/layouts -mindepth 1 -maxdepth 1 -mtime +{{ maxage }} -exec rm -rf {} +
    # without sudo: prune user profiles (~/.local/state/nix/profiles)
    nix-collect-garbage --delete-older-than {{ maxage }}d
    # with sudo: prune root and system profiles (/nix/var/nix/profiles)
    sudo -H nix-collect-garbage --delete-older-than {{ maxage }}d
