{
  config,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      zsh
      #zsh-completions
      #nix-zsh-completions
      #zsh-autosuggestions
      fish
      # direnv
      # nix-direnv
      zoxide
      #starship
    ]
    ++ (
      if pkgs.stdenv.isDarwin then
        [
          bash
        ]
      else
        [ ]
    );
}
