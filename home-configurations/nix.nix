{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    comma
    nvd
    inputs.nix-index.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
