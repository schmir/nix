{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    go_1_22
    gopls
    golangci-lint
    gotestsum

    protobuf
    protoc-gen-go
  ];
}
