{
  description = "Home Manager configuration of ralf";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

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

    my-fonts.url = "git+ssh://git@github.com/schmir/fonts.git?ref=main";
    my-fonts.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs-stable,
      nix-flatpak,
      my-fonts,
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
    flake-utils.lib.eachSystem systems mkSystem
    // {
      nixosConfigurations.sao = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostname = "sao";
        };
        modules = [
          ./configuration.nix
        ];
      };

      nixosConfigurations.triton = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostname = "triton";
        };
        modules = [
          ./configuration.nix
        ];
      };
      nixosConfigurations.halimede = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostname = "halimede";
        };
        modules = [
          ./configuration.nix
        ];
      };

      nixosConfigurations.galatea = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostname = "galatea";
        };
        modules = [
          ./configuration.nix
        ];
      };
    };
}
