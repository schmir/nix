{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    texliveFull
    pdftk
    ghostscript_headless
  ];
}
