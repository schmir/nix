{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    diffstat
    difftastic
    gitFull
    git-lfs
    jujutsu
    meld
    mr
    # nodejs
    pre-commit
    tig
  ];
}
