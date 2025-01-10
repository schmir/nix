{
  inputs,
  config,
  pkgs,
  hostname,
  ...
}:
{
  # Use 'dconf watch /' to observe changes

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-hinting = "full";
      font-antialiasing = "rgba";
      # monospace-font-name = "0xProto Nerd Font Mono";
      # document-font-name = "Inter";
    };

    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "sloppy";
      resize-with-right-button = true;
      button-layout = "appmenu:minimize,maximize,spacer,close";
      # Run 'tput bel' in a terminal to trigger the bell
      audible-bell = false;
      visual-bell = true;
      visual-bell-type = "frame-flash";

    };

    # See https://github.com/GNOME/mutter/blob/main/data/org.gnome.mutter.gschema.xml.in
    "org/gnome/mutter" = {
      edge-tiling = true;
      attach-modal-dialogs = true;
      #experimental-features = [ "scale-monitor-framebuffer" ];
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [
        "terminate:ctrl_alt_bksp"
        "compose:caps"
      ];
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };
  };
}
