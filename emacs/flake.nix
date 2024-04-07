{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.emacs-overlay = {
    url = "github:nix-community/emacs-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      emacs-overlay,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import emacs-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        emacs = pkgs.emacs-git;
        emacs-packages =
          epkgs: with epkgs; [
            vterm
            treesit-grammars.with-all-grammars
            boxquote
            crux
            magit
            eat
          ];
        emacs-with-packages = (pkgs.emacsPackagesFor emacs).emacsWithPackages (emacs-packages);
        emacs-nox = (pkgs.emacsPackagesFor pkgs.emacs-nox).emacsWithPackages (emacs-packages);
      in
      {
        apps.default = {
          type = "app";
          program = "${emacs-with-packages}/bin/emacs";
        };
        defaultPackage = emacs-with-packages;
        packages.default = emacs-with-packages;
        packages.emacs-nox = emacs-nox;
      }
    );
}
