{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    cascadia-code
    dejavu_fonts
    fantasque-sans-mono
    hack-font
    jetbrains-mono
    liberation_ttf
    berkeley-mono-nerd-font
    comic-code-font
  ];
}
