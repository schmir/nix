{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
    (runCommand "keyring" { } ''
      mkdir -p $out/bin
      ln -s ${
        python3.withPackages (ps: [
          ps.keyring
          ps.keyrings-google-artifactregistry-auth
        ])
      }/bin/keyring $out/bin/keyring
    '')
    (runCommand "copier" { } ''
      mkdir -p $out/bin
      ln -s ${copier}/bin/copier $out/bin/copier
    '')

    hadolint
    kubectl
    kubectx
    pulumi-bin
  ];
}
