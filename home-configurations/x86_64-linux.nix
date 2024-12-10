{
  config,
  pkgs,
  pkgs-oldstable,
  ...
}:
{
  home.packages = with pkgs; [
    xterm
    xsel
    dmenu
    wl-clipboard
    psmisc
    lnav
    pkgs-oldstable.docker
  ];
}
