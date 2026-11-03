{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    diffstat
    difftastic
    git
    git-lfs
    jujutsu
    #lefthook
    meld
    yadm
    # nodejs
    # pre-commit
  ];
}
