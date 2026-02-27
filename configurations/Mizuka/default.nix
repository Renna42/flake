{
  inputs,
  pkgs,
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
    ./hardware-configuration.nix
    ./epson_l8168.nix

    ../../nixos/roles/desktop
    # ../../nixos/gui/suites/hyprland.nix
    ../../nixos/gui/suites/plasma.nix
    ../../nixos/gui/game.nix

    ../../nixos/hardware/nvidia.nix
    ../../nixos/hardware/intel-gfx.nix
    ../../nixos/hardware/bluetooth.nix
    ../../nixos/hardware/tpm.nix
    ../../nixos/hardware/xpad.nix
    ../../nixos/hardware/logitech-wireless.nix

    ../../nixos/services/kmscon.nix
    ../../nixos/services/mdns.nix
    ../../nixos/services/proxy.nix
    ../../nixos/services/fprintd.nix
    ../../nixos/services/printing.nix
    ../../nixos/services/podman.nix
    ../../nixos/services/libvirt.nix

    ../../nixos/programs/wine.nix
    ../../nixos/programs/evolution.nix
  ];

  environment.systemPackages = with pkgs; [
    ciel
    squashfsTools
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "auto";
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ntfs"];
    kernelPackages = cachyosKernelPackage;
  };

  renna = {
    homeManager.enable = true;
    enableMirrorSubstituter = true;
    enableCachyosSettings = true;
    enableCompatLibraries = true;
  };

  programs = {
    nexttrace.enable = true;
    obs-studio.enableVirtualCamera = true;
  };

  boot.binfmt = {
    emulatedSystems = ["aarch64-linux"];
    preferStaticEmulators = true; # required to work with podman
  };
}
