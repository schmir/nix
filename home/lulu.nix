{
  config,
  pkgs,
  gpg240-pkgs,
  ...
}:
let
  my-google-cloud-sdk = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      gke-gcloud-auth-plugin
    ]
  );
in
{
  home.packages = with pkgs; [
    my-google-cloud-sdk
    hadolint
    kubectl
    #poppler_utils # pdftotext
  ];
  # ++ (if pkgs.stdenv.isDarwin then [ pinentry_mac ] else [ pinentry ]);
}
