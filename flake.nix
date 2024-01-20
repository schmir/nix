{
  description = "Home Manager configuration of ralf";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      mkHomeConfig = system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = modules;
          extraSpecialArgs = { inherit inputs system; };
        };
      allModules = [
        ./home/base.nix
        ./home/golang.nix
        ./home/clojure.nix
        ./home/most.nix
        ./home/texlive.nix
      ];
    in {
      homeConfigurations."neso" =
        mkHomeConfig "aarch64-darwin" ([ ./machine/neso.nix ] ++ allModules);

      homeConfigurations."neso-empty" =
        mkHomeConfig "aarch64-darwin" [ ./machine/neso.nix ];

      homeConfigurations."cirrus" =
        mkHomeConfig "x86_64-linux" ([ ./machine/cirrus.nix ] ++ allModules);

      homeConfigurations."cirrus-empty" =
        mkHomeConfig "x86_64-linux" [ ./machine/cirrus.nix ];
    };
}
