{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    diffstat
    difftastic
    gitFull
    git-lfs
    glab
    jujutsu
    lefthook
    meld
    mr
    # nodejs
    # pre-commit
    tig
  ];
}
