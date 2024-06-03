{
  config,
  pkgs,
  nox,
  inputs,
  ...
}:
{
  home.packages = [
    inputs.webcam-filters.packages.${pkgs.system}.default
    pkgs.nixgl.nixGLIntel
    #pkgs.webcamoid
  ];
}
