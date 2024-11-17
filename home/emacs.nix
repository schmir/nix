{
  config,
  pkgs,
  nox,
  inputs,
  ...
}:

let
  emacs =
    if nox then
      inputs.schmir-emacs.packages.${pkgs.system}.emacs-nox
    else
      inputs.schmir-emacs.packages.${pkgs.system}.default;
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
    dockerfile-language-server-nodejs
    dprint
    emacs-lsp-booster
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    nixfmt-rfc-style
    msmtp
    multimarkdown
    nil
    nixd
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.typescript-language-server
    ruff
    shellcheck
    shfmt
    ollama
  ];
}
