{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./epson_l8168.nix
    ../../nixos/disk-layouts/root-data-separate.nix

    ../../nixos/roles/desktop
    # ../../nixos/gui/suites/hyprland.nix
    ../../nixos/gui/suites/plasma.nix

    ../../nixos/hardware/nvidia.nix
    ../../nixos/hardware/intel-gfx.nix
    ../../nixos/hardware/bluetooth.nix
    ../../nixos/hardware/tpm.nix
    ../../nixos/hardware/xpad.nix
    ../../nixos/hardware/logitech-wireless.nix
    ../../nixos/hardware/ddcci.nix

    ../../nixos/services/kmscon.nix
    ../../nixos/services/mdns.nix
    ../../nixos/services/proxy.nix
    ../../nixos/services/fprintd.nix
    ../../nixos/services/printing.nix
    ../../nixos/services/podman.nix
    ../../nixos/services/libvirt.nix
    ../../nixos/services/samba.nix
    ../../nixos/services/zram.nix

    ../../nixos/programs/game
    ../../nixos/programs/wine.nix
    ../../nixos/programs/evolution.nix
    ../../nixos/programs/odd.nix
    ../../nixos/programs/wireshark.nix
  ];

  environment.systemPackages = with pkgs; [
    ciel
    squashfsTools
    gparted-full
    nvme-cli
  ];

  renna = {
    homeManager.enable = true;
    enableMirrorSubstituter = true;
    enableCachyosSettings = true;
    enableCompatLibraries = true;
  };

  programs = {
    nexttrace.enable = true;
    obs-studio.enableVirtualCamera = true;
    virt-manager.enable = true;
  };

  boot.binfmt = {
    emulatedSystems = ["aarch64-linux"];
    preferStaticEmulators = true; # required to work with podman
  };
}
