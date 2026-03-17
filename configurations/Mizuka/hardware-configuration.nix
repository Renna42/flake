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
        configurationLimit = 10;
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

  # To make sops-nix happy
  fileSystems."/home".neededForBoot = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
