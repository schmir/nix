# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  hostname,
  ...
}:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
    # Include the results of the hardware scan.
    ./${hostname}/hardware-configuration.nix
  ];
  nixpkgs.overlays = [ inputs.my-fonts.overlays.default ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_6_10;
  networking.hostName = "${hostname}"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  boot.kernel.sysctl = {
    "kernel.dmesg_restrict" = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Turn of wifi powersave, otherwise I have high latency when pinging the WIFI Router on the P16s
  networking.networkmanager.wifi.powersave = false;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.fwupd.enable = true;
  services.fprintd.enable = true;
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "ca.desrt.dconf-editor"
    "com.google.Chrome"
    "com.slack.Slack"
    "com.spotify.Client"
    "com.vivaldi.Vivaldi"
    "hu.irl.cameractrls"
    "org.gnome.SimpleScan"
    "org.mozilla.firefox"
    "org.torproject.torbrowser-launcher"
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ralf = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Ralf Schmitt";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "docker"
      "scanner"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFqynqQEKJPRMj3/QsHoPIg0x5TfxaxR88NrVpZ4/1D ralf@neso.fritz.box"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLBDG1au9pmxlrOrE/24ScUJ4hm70G7rCGXlQ/Q1MxW ralf@cirrus"
    ];
  };

  users.mutableUsers = true;

  # users.users.rr = {
  #   uid = 1973;
  #   shell = pkgs.fish;
  #   isNormalUser = true;
  #   description = "ralf";
  #   extraGroups = [
  #     "networkmanager"
  #     "wheel"
  #     "libvirtd"
  #     "docker"
  #   ];
  #   packages = with pkgs; [
  #     #  thunderbird
  #   ];
  #   openssh.authorizedKeys.keys = [
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICFqynqQEKJPRMj3/QsHoPIg0x5TfxaxR88NrVpZ4/1D ralf@neso.fritz.box"
  #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLBDG1au9pmxlrOrE/24ScUJ4hm70G7rCGXlQ/Q1MxW ralf@cirrus"
  #   ];
  # };

  programs.firefox.enable = false;
  programs.nano.enable = false;

  # kvm / virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
  ];

  # Fix VPN, see https://github.com/NixOS/nixpkgs/issues/375352#issue-2800029311
  environment.etc."strongswan.conf".text = "";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # nix-zsh-completions
    # zsh-autosuggestions
    # zsh-completions
    btop
    compsize
    coreutils
    direnv
    distrobox
    emacs
    git
    gparted
    hdparm
    iotop
    moreutils
    nix-direnv
    tarsnap
    virt-viewer
    wezterm
    wirelesstools
    xfsprogs
    zoxide
  ];

  environment.gnome.excludePackages = [ pkgs.simple-scan ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.pcscd.enable = true;

  # Suspend-then-hibernate everywhere
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=60m
    '';
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
    SuspendState=mem
  '';

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  programs.zsh.enable = true;
  #programs.fish.enable = true;
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # noto-fonts-extra
      cascadia-code
      dejavu_fonts
      fantasque-sans-mono
      fira-code
      fira-code-symbols
      hack-font
      jetbrains-mono
      liberation_ttf
      #nerdfonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      ubuntu_font_family
      berkeley-mono-nerd-font
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
