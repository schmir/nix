{ config, pkgs, nox, ... }:

{
  services.syncthing.enable = true;

  home.packages = with pkgs; [ syncthing ];
}
