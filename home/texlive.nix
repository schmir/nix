{
  config,
  pkgs,
  pkgs-stable,
  ...
}:

{
  home.packages = with pkgs; [
    pkgs-stable.texliveFull
    pdftk
    ghostscript_headless
  ];
}
