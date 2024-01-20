{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ ];
        pkgs = import nixpkgs { inherit system overlays; };
      in with pkgs; {
        devShells.default = mkShell {
          buildInputs = [ ];
          packages = [
            pkgs.coreutils
            pkgs.moreutils

            pkgs.gnumake
            pkgs.ninja
            pkgs.bmake
            pkgs.circleci-cli

            pkgs.clojure
            pkgs.babashka
            pkgs.neil
            pkgs.clj-kondo

            pkgs.go
            pkgs.gopls
            pkgs.golangci-lint
            pkgs.gotestsum

            pkgs.protobuf
            pkgs.protoc-gen-go

            pkgs.cloc
            pkgs.pre-commit
            pkgs.nodejs_18

            pkgs.ripgrep
            pkgs.git
            pkgs.tig
            pkgs.difftastic
            pkgs.shellcheck
            pkgs.shfmt

            pkgs.emacs
            pkgs.emacsPackages.vterm
            pkgs.hunspell
            pkgs.hunspellDicts.de_DE
            pkgs.hunspellDicts.en_US
            pkgs.nixfmt
            pkgs.pass
            pkgs.apg
            pkgs.pwgen
            pkgs.yadm
            pkgs.pinentry
            # pkgs.pinentry_mac

            pkgs.rclone
            pkgs.restic
            pkgs.fzf

            pkgs.texliveFull
            pkgs.pdftk
            pkgs.ghostscript_headless

            pkgs.entr
            pkgs.curl
            pkgs.jq
            pkgs.bat
            pkgs.fd

            pkgs.dogdns
            pkgs.mtr
          ];
        };
      });
}
