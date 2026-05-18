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
    ../../nixos/hardware/disable-watchdog.nix
    ../../nixos/hardware/hdr.nix

    ../../nixos/services/pipewire
    ../../nixos/services/kmscon.nix
    ../../nixos/services/mdns.nix
    ../../nixos/services/proxy.nix
    ../../nixos/services/fprintd.nix
    ../../nixos/services/printing.nix
    ../../nixos/services/podman.nix
    ../../nixos/services/libvirt.nix
    ../../nixos/services/samba.nix
    ../../nixos/services/zram.nix
    ../../nixos/services/tailscale.nix

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
    kernel = pkgs.cachyosKernels.linux-cachyos-latest-lto.override {
      processorOpt = "x86_64-v3";
    };
    homeManager.enable = true;
    enableMirrorSubstituter = true;
    enableCompatLibraries = true;
  };

  programs = {
    nexttrace.enable = true;
    obs-studio.enableVirtualCamera = true;
    virt-manager.enable = true;
  };

  # Too much jobs may cause OOM
  nix.settings.max-jobs = 8;

  lantian.qemu-user-static-binfmt = {
    enable = true;
    package = pkgs.nur-xddxdd.qemu-user-static;
  };
}
