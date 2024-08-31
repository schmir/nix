{
  config,
  pkgs,
  gpg240-pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    google-cloud-sdk
    #poppler_utils # pdftotext
  ];
  # ++ (if pkgs.stdenv.isDarwin then [ pinentry_mac ] else [ pinentry ]);
}
