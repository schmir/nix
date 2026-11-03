{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    imagemagick
    img2pdf
    pdftk
    ghostscript_headless
    graphviz
  ];
}
