{
  config,
  pkgs,
  ...
}:

{
  fonts.fontconfig.enable = true;
  home.packages =
    with pkgs;
    [
      cascadia-code
      dejavu_fonts
      fantasque-sans-mono
      hack-font
      jetbrains-mono
      liberation_ttf
    ];
}

