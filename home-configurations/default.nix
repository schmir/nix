{
  self,
  nixpkgs,
  nixpkgs-stable,
  gpg240-nixpkgs,
  home-manager,
  emacs-overlay,
  nixgl,
  system,
  ...
}@inputs:
let
  mkHomeConfig =
    system: modules:
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
    ./x11.nix
    ./syncthing.nix
  ];
  allModules = (
    mostModules
    ++ [
      ./texlive.nix
      ./x11.nix
      ./${system}.nix
    ]
  );
in
{
  "ralf" = mkHomeConfig system allModules;
}
