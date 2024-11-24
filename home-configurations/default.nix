{
  self,
  nixpkgs,
  nixpkgs-stable,
  gpg240-nixpkgs,
  home-manager,
  emacs-overlay,
  system,
  ...
}@inputs:
let
  mkHomeConfig =
    system: modules:
    let
      overlays = [
        (import emacs-overlay)
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
          gpg240-pkgs
          pkgs-stable
          ;
      };
    };
  mostModules = [
    ./ralf.nix
    ./base.nix
    ./shells.nix
    ./clojure.nix
    ./emacs.nix
    ./golang.nix
    ./most.nix
    ./python.nix
    ./vcs.nix
    ./lulu.nix
    ./syncthing.nix
    ./${system}.nix
  ];
  allModules = (
    mostModules
    ++ [
      ./texlive.nix
    ]
  );
in
{
  "ralf" = mkHomeConfig system mostModules;
}
