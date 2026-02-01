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
        "aarch64-linux"
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
          system.primaryUser = "ralf";
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
          ids.gids.nixbld = 350;
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
              "firefox"
              "tor-browser"
              "utm"
              "vivaldi"
              "openmtp"
            ];
          };
          system.defaults.NSGlobalDomain = {
            # keyboard navigation in dialogs
            AppleKeyboardUIMode = 3;

            # disable press-and-hold for keys in favor of key repeat
            ApplePressAndHoldEnabled = false;

            # fast key repeat rate when hold
            KeyRepeat = 1; # lowest value for fastest repeat
            InitialKeyRepeat = 15; # delay before repeat starts

            # disable auto-correction annoyances
            NSAutomaticCapitalizationEnabled = false; # no auto-capitalization
            NSAutomaticDashSubstitutionEnabled = false; # no smart dashes
            NSAutomaticPeriodSubstitutionEnabled = false; # no double-space period
            NSAutomaticQuoteSubstitutionEnabled = false; # no smart quotes
            NSAutomaticSpellingCorrectionEnabled = false; # no auto-correct

            # faster window animations
            NSAutomaticWindowAnimationsEnabled = false; # faster window opening
            NSWindowResizeTime = 0.001; # faster resize
            _HIHideMenuBar = true; # auto-hide menu bar
          };
          programs.zsh.enable = true;
          system.defaults.dock = {
            wvous-tl-corner = 2; # top-left hot corner: mission control
            show-recents = false; # don't show recent apps
            orientation = "bottom"; # dock position
            autohide = true; # automatically hide the dock
            autohide-delay = 0.0; # no delay before showing
            autohide-time-modifier = 0.2; # faster show/hide animation
            mineffect = "scale"; # faster than genie effect
            minimize-to-application = true; # minimize windows into app icon
            mru-spaces = false; # don't auto-rearrange spaces by usage
            tilesize = 48; # icon size in pixels
            persistent-apps = [
              "/System/Applications/Mail.app"
              "/System/Applications/Calendar.app"
              "/System/Applications/Notes.app"
              "/System/Applications/Photos.app"
              "/Applications/WezTerm.app"
              "/Applications/Vivaldi.app"
              "/Users/ralf/Applications/Home Manager Apps/Emacs.app"
            ];
          };
          system.defaults.finder = {
            ShowPathbar = true; # show path breadcrumbs at bottom
            ShowStatusBar = true; # show status bar at bottom
            FXPreferredViewStyle = "clmv"; # default to column view
            QuitMenuItem = true; # allow quitting Finder via Cmd+Q
            _FXShowPosixPathInTitle = true; # show full path in title bar
            _FXSortFoldersFirst = true; # sort folders before files
          };
          security.pam.services.sudo_local.touchIdAuth = true;
          system.defaults.loginwindow.GuestEnabled = false;
          system.defaults.menuExtraClock.Show24Hour = true;
          system.defaults.trackpad.TrackpadRightClick = true;
          system.defaults.WindowManager = {
            # disable window tiling when dragging to screen edges
            EnableTiledWindowMargins = false;
            EnableTopTilingByEdgeDrag = false;
            EnableTilingByEdgeDrag = true;
          };
          system.defaults.screencapture = {
            location = "~/Screenshots"; # where screenshots are saved
            type = "png"; # screenshot format
            disable-shadow = true; # no window shadows in screenshots
          };
          system.defaults.SoftwareUpdate = {
            AutomaticallyInstallMacOSUpdates = false; # don't auto-install macOS updates
          };
          system.defaults.screensaver = {
            askForPassword = true; # require password to unlock
            askForPasswordDelay = 5; # seconds before password required
          };
          system.defaults.LaunchServices = {
            LSQuarantine = false; # disable "Are you sure you want to open?" dialog
          };
          system.keyboard = {
            enableKeyMapping = true;
            remapCapsLockToControl = true;
          };
          system.defaults.CustomUserPreferences = {
            "com.apple.desktopservices" = {
              DSDontWriteNetworkStores = true; # no .DS_Store on network volumes
              DSDontWriteUSBStores = true; # no .DS_Store on USB drives
            };
          };
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
