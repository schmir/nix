{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.nixos-rebuild ];
}
