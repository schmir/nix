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
    ++ (
      if pkgs.stdenv.hostPlatform.isDarwin then
        [
          # also provide the generic name `pinentry`
          (symlinkJoin {
            name = "pinentry-mac-with-alias";
            paths = [ pinentry_mac ];
            postBuild = ''
              ln -s pinentry-mac $out/bin/pinentry
            '';
          })
        ]
      else
        [ pinentry-gnome3 ]
    );
}
