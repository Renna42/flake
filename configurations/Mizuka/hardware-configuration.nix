{
  config,
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  cachyosKernel = pkgs.cachyosKernels.linux-cachyos-latest-lto.override {
    processorOpt = "x86_64-v3";
  };
  cachyosKernelPackage = let
    # helpers.nix provides a few utilities for building kernel with LTO.
    helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" {};
  in
    helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor cachyosKernel);
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sr_mod"
    ];
    kernelModules = ["kvm-intel"];
    supportedFilesystems = ["ntfs"];
    kernelPackages = cachyosKernelPackage;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d7edc60b-44cf-4c62-a3f9-0d9e1c75196b";
    fsType = "xfs";
    options = ["relatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/7a0eea28-f88b-4a1e-987b-03c0f35afb44";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
      "relatime"
    ];

    # To make sops-nix happy
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/966D-FDA3";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
