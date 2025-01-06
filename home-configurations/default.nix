{
  self,
  nixpkgs,
  nixpkgs-stable,
  home-manager,
  system,
  ...
}@inputs:
let
  mkHomeConfig =
    system: modules:
    let
      overlays = [
        inputs.my-fonts.overlays.default
      ];
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
    #    ./python.nix
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
