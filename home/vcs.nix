{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    diffstat
    difftastic
    git
    git-lfs
    jujutsu
    meld
    mr
    # nodejs
    pre-commit
    tig
  ];
}
