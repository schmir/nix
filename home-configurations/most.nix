{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # build tools
    gnumake
    ninja
    bmake
    #circleci-cli

    cloc
    treefmt

    stow

    bkt
    hyperfine
  ];
}
