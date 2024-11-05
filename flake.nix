{
  description = "Home Manager configuration of ralf";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    gpg240-nixpkgs.url = "github:nixos/nixpkgs?rev=5a8650469a9f8a1958ff9373bd27fb8e54c4365d";

    # Specify the source of Home Manager and Nixpkgs.
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixfmt.url = "github:NixOS/nixfmt";
    schmir-emacs.url = "github:schmir/.emacs.d";
    webcam-filters = {
      url = "github:jashandeep-sohi/webcam-filters";
      #url = "github:schmir/webcam-filters";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index.url = "github:nix-community/nix-index";
    nix-index.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      gpg240-nixpkgs,
      home-manager,
      emacs-overlay,
      nixfmt,
      schmir-emacs,
      nix-index,
      webcam-filters,
      nixgl,
      ...
    }@inputs:
    let
      mkHomeConfig =
        system: nox: modules:
        let
          overlays = [
            (import emacs-overlay)
            nixgl.overlay
          ];
          gpg240-pkgs = import gpg240-nixpkgs { inherit system overlays; };
          pkgs-stable = import nixpkgs-stable { inherit system overlays; };
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
          modules = modules;
          extraSpecialArgs = {
            inherit
              inputs
              system
              nox
              gpg240-pkgs
              pkgs-stable
              ;
          };
        };
      mostModules = [
        ./home/base.nix
        ./home/clojure.nix
        ./home/emacs.nix
        ./home/golang.nix
        ./home/most.nix
        ./home/python.nix
        ./home/vcs.nix
      ];
      allModules = (
        mostModules
        ++ [
          ./home/texlive.nix
          ./home/x11.nix
        ]
      );
    in
    {
      homeConfigurations."neso" = mkHomeConfig "aarch64-darwin" false (
        [ ./machine/neso.nix ]
        ++ mostModules
        ++ [
          ./home/texlive.nix
          ./home/lulu.nix
        ]
      );

      homeConfigurations."sao" = mkHomeConfig "x86_64-linux" false (
        [
          ./machine/cirrus.nix
          ./home/fonts.nix
          # ./home/webcam.nix
          ./home/syncthing.nix
          ./home/lulu.nix
        ]
        ++ allModules
      );

      homeConfigurations."triton" = mkHomeConfig "x86_64-linux" false (
        [
          ./machine/cirrus.nix
          ./home/syncthing.nix
          ./home/lulu.nix
          ./home/x11.nix
        ]
        ++ mostModules
      );

      homeConfigurations."galatea" = mkHomeConfig "x86_64-linux" false (
        [
          ./machine/cirrus.nix
          ./home/syncthing.nix
          ./home/lulu.nix
          ./home/x11.nix
        ]
        ++ mostModules
      );

      homeConfigurations."arm" = mkHomeConfig "aarch64-linux" true (
        [ ./machine/cirrus.nix ] ++ allModules
      );

    };
}
