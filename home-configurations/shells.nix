{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      zsh
      atuin
      #zsh-completions
      #nix-zsh-completions
      #zsh-autosuggestions
      fish
      # direnv
      # nix-direnv
      zoxide
      starship
    ]
    ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin bash;
}
