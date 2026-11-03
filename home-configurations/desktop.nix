{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Tools for X11 and Wayland desktops, which only exist on Linux.
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
    with pkgs;
    [
      xterm
      xsel
      wl-clipboard
      diffpdf
    ]
  );
}
