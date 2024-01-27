{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # build tools
    gnumake
    ninja
    bmake
    circleci-cli

    cloc
    pre-commit
    nodejs

    # git
    git
    tig
    difftastic
    shellcheck
    shfmt

    pass
    gnupg
    apg
    pwgen
    yadm
    pinentry
    # pinentry_mac

    imagemagick
    img2pdf

    rclone
    restic

  ];
}
