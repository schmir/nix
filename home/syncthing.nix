{ config, pkgs, nox, ... }:

{
  services.syncthing = {
    enable = true;
    tray = false;
  };

  home.packages = with pkgs; [ syncthing ];
}
