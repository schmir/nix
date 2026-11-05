{
  description = "Home Manager configuration of ralf";

  inputs = {
    sync.url = "github:schmir/sync-flake";
    nixpkgs-stable.follows = "sync/nixpkgs-stable";
    nixpkgs.follows = "sync/nixpkgs";
    flake-utils.follows = "sync/flake-utils";
    home-manager.follows = "sync/home-manager";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "sync/nixpkgs";

    schmir-emacs.url = "github:schmir/.emacs.d";

    nix-index.url = "github:nix-community/nix-index";
    nix-index.inputs.nixpkgs.follows = "nixpkgs";

    my-fonts.url = "git+ssh://git@github.com/schmir/fonts.git?ref=main";
    my-fonts.inputs.nixpkgs.follows = "nixpkgs";

    spork.url = "github:janet-lang/spork";
    spork.flake = false;
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs-stable,
      nix-flatpak,
      my-fonts,
      nix-darwin,
      ...
    }@inputs:
    let
      # x86_64-darwin is gone: nixpkgs 26.11 dropped support for it.
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # The NixOS release each host was first installed with; see
      # system.stateVersion. This is per machine, not a version to bump.
      hostStateVersions = {
        sao = "24.05";
        triton = "24.05";
        halimede = "24.11";
        galatea = "24.05";
      };

      mkSystem =
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          homeConfigurations = import ./home-configurations (inputs // { inherit system; });

          # treefmt, driven by ./treefmt.toml, with every formatter that file
          # names on PATH.
          treefmt = pkgs.writeShellApplication {
            name = "treefmt";
            runtimeInputs = with pkgs; [
              nixfmt
              prettier
              shfmt
              taplo
            ];
            text = ''exec ${pkgs.lib.getExe pkgs.treefmt} "$@"'';
          };
        in
        {
          legacyPackages.homeConfigurations = homeConfigurations;

          # `nix fmt`
          formatter = treefmt;

          # `nix flake check` also evaluates nixosConfigurations and
          # darwinConfigurations on its own; the home configurations live under
          # legacyPackages, so they need to be added here explicitly.
          checks = {
            formatting = pkgs.runCommand "check-formatting" { nativeBuildInputs = [ treefmt ]; } ''
              cp --recursive --no-preserve=mode ${self} src
              treefmt --ci --walk filesystem --tree-root src --config-file src/treefmt.toml
              touch $out
            '';
          }
          // pkgs.lib.mapAttrs' (
            name: config: pkgs.lib.nameValuePair "home-${name}" config.activationPackage
          ) homeConfigurations;
        };
    in
    flake-utils.lib.eachSystem systems mkSystem
    // {
      # Every host builds the same configuration.nix; the hostname picks the
      # matching hardware-configuration.nix.
      nixosConfigurations = builtins.mapAttrs (
        hostname: stateVersion:
        nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs hostname stateVersion;
          };
          modules = [
            ./configuration.nix
          ];
        }
      ) hostStateVersions;

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#neso
      darwinConfigurations."neso" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = [ ./darwin/neso.nix ];
      };
    };
}
