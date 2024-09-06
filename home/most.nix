{
  config,
  pkgs,
  gpg240-pkgs,
  inputs,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      # build tools
      gnumake
      ninja
      bmake
      circleci-cli

      cloc
      pre-commit
      nodejs
      python3

      # git
      git
      tig
      difftastic
      shellcheck
      shfmt

      gpg240-pkgs.pass
      gpg240-pkgs.gnupg
      apg
      pwgen
      yadm

      imagemagick
      img2pdf

      rclone
      restic

      nixos-rebuild
      inputs.nix-index.packages.${pkgs.system}.default
    ]
    ++ (if pkgs.stdenv.isDarwin then [ pinentry_mac ] else [ pinentry ]);
}
