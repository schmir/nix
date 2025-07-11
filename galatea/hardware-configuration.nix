# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.luks.devices."luks-b74f1f8f-d46a-4d10-9bf3-c10fab4a97fb".device =
    "/dev/disk/by-uuid/b74f1f8f-d46a-4d10-9bf3-c10fab4a97fb";

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];

  # From https://www.reddit.com/r/Dell/comments/zf386l/xps_15_9500_debian_11_peace_at_last/?rdt=59497
  #
  #   Because God hates us, when suspending and unsuspending the kernel modules need to be unloaded
  #   and reloaded otherwise you'll be offline once you unsuspend.
  #
  powerManagement.powerDownCommands = "${pkgs.kmod}/bin/rmmod ath11k_pci";
  powerManagement.resumeCommands = "${pkgs.kmod}/bin/modprobe ath11k_pci";

  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # boot.kernelPackages = pkgs.linuxPackagesFor (
  #   pkgs.linux_6_10.override {
  #     argsOverride = rec {
  #       src = pkgs.fetchurl {
  #         url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
  #         sha256 = "1adkbn6dqbpzlr3x87a18mhnygphmvx3ffscwa67090qy1zmc3ch";
  #       };
  #       version = "6.10.7";
  #       modDirVersion = "6.10.7";
  #     };
  #   }
  # );

  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/79215d33-22b3-41a5-a75a-22525fd82c8e";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-9d431816-7f0f-4e40-8f74-242a24ceadbc".device =
    "/dev/disk/by-uuid/9d431816-7f0f-4e40-8f74-242a24ceadbc";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/60FB-D6E0";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/repos" = {
    device = "/home/ralf/repos";
    options = [
      "bind"
      "X-mount.idmap=u:1000:1001:1 g:100:1001:1"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/969b42aa-24c4-48ab-b5f3-a79a03b46aac"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  networking.extraHosts = ''
    10.5.0.13 gcp-storage-emulator
  '';

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  virtualisation.docker.daemon.settings = {
    features = {
      containerd-snapshotter = true;
    };
  };

  boot.binfmt = {
    emulatedSystems = [
      "aarch64-linux"
      "armv6l-linux"
      "armv7l-linux"
    ];
    preferStaticEmulators = true;
    registrations.aarch64-linux = {
      fixBinary = true;
      matchCredentials = true;
      wrapInterpreterInShell = false;
    };
  };
}
