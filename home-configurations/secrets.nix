{ config, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
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
    ]
    ++ (if pkgs.stdenv.hostPlatform.isDarwin then [ pinentry_mac ] else [ pinentry-gnome3 ]);
}
