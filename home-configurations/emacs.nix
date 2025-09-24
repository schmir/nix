{
  config,
  pkgs,
  inputs,
  ...
}:

let
  emacs = inputs.schmir-emacs.packages.${pkgs.system}.default;
in
{
  programs.emacs = {
    enable = true;
    package = emacs;
  };
  services.emacs = {
    enable = pkgs.stdenv.isLinux;
    package = emacs;
    startWithUserSession = "graphical";
  };

  home.packages = with pkgs; [
    clojure-lsp
    dockerfile-language-server
    dprint
    #emacs-lsp-booster
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    isync
    nixfmt-rfc-style
    msmtp
    multimarkdown
    nil
    nixd
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.typescript-language-server
    pyright
    ruff
    shellcheck
    shfmt
    ollama
  ];
}
