{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mkcert
    openssl
  ];
}
