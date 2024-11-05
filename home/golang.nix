{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    go
    gopls
    golangci-lint
    gotestsum

    protobuf
    protoc-gen-go
  ];
}
