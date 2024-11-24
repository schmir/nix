{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    xterm
    xsel
    dmenu
    wl-clipboard
    psmisc
  ];
}
