{ config, pkgs, nox, ... }: {
  home.packages = if nox then [ ] else with pkgs; [ xterm xsel dmenu ];
}
