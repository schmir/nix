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
      dive
      hadolint
    ]
    # NixOS hosts get podman from configuration.nix.
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      colima
      docker-client
      podman
    ];
}
