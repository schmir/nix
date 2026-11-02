{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    claude-code
    codex
    pi-coding-agent

    # build tools
    gnumake
    ninja
    bmake
    #circleci-cli

    cloc
    treefmt
    taplo

    stow
    yadm

    bkt
    hyperfine

    nixos-rebuild
    inputs.nix-index.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
