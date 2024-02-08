{ config, pkgs, nox, ... }:

let

  emacs = if nox then pkgs.emacs-nox else pkgs.emacs-git;
  emacs-packages = epkgs: with epkgs; [ vterm ];
  emacs-with-packages =
    (pkgs.emacsPackagesFor emacs).emacsWithPackages (emacs-packages);
in {
  programs.emacs = {
    enable = true;
    package = emacs-with-packages;
  };
  services.emacs = {
    enable = pkgs.stdenv.isLinux;
    package = emacs-with-packages;
  };

  home.packages = with pkgs; [
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    nixfmt
    msmtp
    multimarkdown
    # eglot takes ages to startup when using pyright as language server
    #nodePackages.pyright
    python311Packages.python-lsp-server
    ruff
  ];
}
