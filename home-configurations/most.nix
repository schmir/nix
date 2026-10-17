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
      claude-code
      codex
      pi-coding-agent

      # build tools
      gnumake
      ninja
      bmake
      #circleci-cli

      cloc
      treefmt
      taplo

      age
      age-plugin-yubikey
      apg
      gnupg
      # nixpkgs installs platform.sh to lib/password-store, but the script sources lib/passage
      (passage.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          ln -s password-store $out/lib/passage
        '';
      }))
      pwgen
      rage

      stow
      yadm

      imagemagick
      img2pdf
      pdftk
      ghostscript_headless

      rclone
      restic

      bkt
      hyperfine

      nixos-rebuild
      inputs.nix-index.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ (if pkgs.stdenv.hostPlatform.isDarwin then [ pinentry_mac ] else [ pinentry-gnome3 ]);
}
