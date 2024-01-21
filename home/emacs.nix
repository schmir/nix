{ config, pkgs, ... }:

let
  emacs = pkgs.emacs-git;
  #emacs = pkgs.emacs;
  emacs-with-packages = (pkgs.emacsPackagesFor emacs).emacsWithPackages
    (epkgs: [
      epkgs.magit
      epkgs.tree-sitter
      epkgs.tree-sitter-langs
      epkgs.vterm
    ]);
in {
  programs.emacs = {
    enable = true;
    package = emacs-with-packages;
  };

  home.packages = with pkgs; [
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    nixfmt
  ];
}
