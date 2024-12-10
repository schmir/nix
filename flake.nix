{
  description = "Home Manager configuration of ralf";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    gpg240-nixpkgs.url = "github:nixos/nixpkgs?rev=5a8650469a9f8a1958ff9373bd27fb8e54c4365d";
    nixpkgs-oldstable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Specify the source of Home Manager and Nixpkgs.
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    schmir-emacs.url = "github:schmir/.emacs.d";

    nix-index.url = "github:nix-community/nix-index";
    nix-index.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      flake-utils,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      mkSystem = system: {
        legacyPackages.homeConfigurations = import ./home-configurations (inputs // { inherit system; });
      };
    in
    flake-utils.lib.eachSystem systems mkSystem;
}
