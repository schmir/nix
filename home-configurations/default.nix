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
    ./base.nix
    ./shells.nix
    ./clojure.nix
    ./emacs.nix
    ./golang.nix
    ./janet.nix
    ./most.nix
    ./ai.nix
    ./nix.nix
    ./nixos.nix
    ./secrets.nix
    ./documents.nix
    ./backup.nix
    ./containers.nix
    ./desktop.nix
    ./tls.nix
    #    ./python.nix
    ./vcs.nix
    ./lulu.nix
    ./syncthing.nix
    ./${system}.nix
    ./dconf.nix
  ];

  # The 'user' account runs inside Qubes OS qubes. Every qube picks the
  # combination that matches its purpose.
  qubeCore = [
    ./user.nix
    ./base.nix
    ./shells.nix
    ./vcs.nix
    ./nix.nix
  ];
  qubeDev = qubeCore ++ [
    ./emacs.nix
    ./most.nix
    ./ai.nix
    ./desktop.nix
  ];
in
{
  "ralf" = mkHomeConfig system ([ ./ralf.nix ] ++ mostModules);

  "user" = mkHomeConfig system qubeCore;
  "user-clojure" = mkHomeConfig system (qubeDev ++ [ ./clojure.nix ]);
  "user-work" = mkHomeConfig system (
    qubeDev
    ++ [
      ./containers.nix
      ./golang.nix
      ./lulu.nix
      ./tls.nix
    ]
  );
}
