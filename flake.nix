{
  description = "Home Manager configuration of ralf";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, ... }@inputs:
    let
      overlays = [ (import emacs-overlay) ];
      mkHomeConfig = system: nox: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system overlays; };
          modules = modules;

          extraSpecialArgs = { inherit inputs system nox; };
        };
      mostModules = [
        ./home/base.nix
        ./home/emacs.nix
        ./home/golang.nix
        ./home/clojure.nix
        ./home/most.nix
      ];
      allModules = (mostModules ++ [ ./home/texlive.nix ./home/x11.nix ]);
    in {
      homeConfigurations."neso" = mkHomeConfig "aarch64-darwin" false
        ([ ./machine/neso.nix ] ++ mostModules ++ [ ./home/texlive.nix ]);

      homeConfigurations."neso-empty" =
        mkHomeConfig "aarch64-darwin" false [ ./machine/neso.nix ];

      homeConfigurations."cirrus" = mkHomeConfig "x86_64-linux" false
        ([ ./machine/cirrus.nix ./home/syncthing.nix ] ++ allModules);

      homeConfigurations."triton" = mkHomeConfig "x86_64-linux" false
        ([ ./machine/cirrus.nix ./home/syncthing.nix ] ++ allModules);

      homeConfigurations."cirrus-empty" =
        mkHomeConfig "x86_64-linux" false [ ./machine/cirrus.nix ];

      homeConfigurations."cirrus-nox" = mkHomeConfig "x86_64-linux" true
        ([ ./machine/cirrus.nix ] ++ mostModules);

      homeConfigurations."arm" = mkHomeConfig "aarch64-linux" true
        ([ ./machine/cirrus.nix ] ++ allModules);

      homeConfigurations."arm-empty" =
        mkHomeConfig "aarch64-linux" true [ ./machine/cirrus.nix ];

    };
}
