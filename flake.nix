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
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      mkSystem = system: {
        legacyPackages.homeConfigurations = import ./home-configurations (inputs // { inherit system; });
      };
      darwin-configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
          ];

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
          ids.gids.nixbld = 30000;
          homebrew = {
            enable = true;
            onActivation = {
              autoUpdate = true;
              upgrade = true;
              cleanup = "zap";
              extraFlags = [ "--verbose" ];
            };

            taps = [ ];
            brews = [ ];
            casks = [
              "eloston-chromium"
              "firefox"
              "google-chrome"
              "slack"
              "tor-browser"
              "utm"
              "openmtp"
            ];
          };
          system.defaults.NSGlobalDomain = {
            # keyboard navigation in dialogs
            AppleKeyboardUIMode = 3;

            # disable press-and-hold for keys in favor of key repeat
            ApplePressAndHoldEnabled = false;

            # fast key repeat rate when hold
            KeyRepeat = 1;
            InitialKeyRepeat = 15;
          };
          programs.zsh.enable = true;
          system.defaults.dock.wvous-tl-corner = 2;
          system.defaults.dock.show-recents = false;
          system.defaults.dock.orientation = "bottom";
          system.defaults.finder.ShowPathbar = true;
          security.pam.services.sudo_local.touchIdAuth = true;
          system.defaults.finder.QuitMenuItem = true;
          system.defaults.finder.ShowStatusBar = true;
          system.defaults.finder._FXShowPosixPathInTitle = true;
          system.defaults.finder._FXSortFoldersFirst = true;
          system.defaults.loginwindow.GuestEnabled = false;
          system.defaults.menuExtraClock.Show24Hour = true;
        };

    in
    flake-utils.lib.eachSystem systems mkSystem
    // {
      nixosConfigurations.sao = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostname = "sao";
        };
        modules = [
          ./configuration.nix
        ];
      };

      nixosConfigurations.triton = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostname = "triton";
        };
        modules = [
          ./configuration.nix
        ];
      };
      nixosConfigurations.halimede = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostname = "halimede";
        };
        modules = [
          ./configuration.nix
        ];
      };

      nixosConfigurations.galatea = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostname = "galatea";
        };
        modules = [
          ./configuration.nix
        ];
      };
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#neso
      darwinConfigurations."neso" = nix-darwin.lib.darwinSystem {
        modules = [ darwin-configuration ];
      };
    };
}
