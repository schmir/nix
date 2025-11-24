{
  config,
  pkgs,
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
      treefmt
      taplo

      age
      age-plugin-yubikey
      apg
      gnupg
      passage
      pwgen
      rage

      yadm

      imagemagick
      img2pdf
      pdftk
      ghostscript_headless

      rclone
      restic

      hyperfine

      nixos-rebuild
      inputs.nix-index.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ (if pkgs.stdenv.isDarwin then [ pinentry_mac ] else [ pinentry-gnome3 ]);
}
