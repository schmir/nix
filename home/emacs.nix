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
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    #nixfmt-rfc-style
    inputs.nixfmt.packages.${system}.nixfmt
    msmtp
    multimarkdown
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    # eglot takes ages to startup when using pyright as language server
    #nodePackages.pyright
    #python311Packages.python-lsp-server
    dockerfile-language-server-nodejs
    nil
    ruff
    clojure-lsp
    emacs-lsp-booster
  ];
}
