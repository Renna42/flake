{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./epson_l8168.nix
    ../../nixos/disk-layouts/root-data-separate.nix

    ../../nixos/roles/desktop
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

  environment.systemPackages = with pkgs;
    [
      ciel
      squashfsTools
      gparted-full
      nvme-cli
    ]
    ++ (with unstablePkgs; [
      bitwarden-desktop
    ]);

  renna = {
    kernel = pkgs.cachyosKernels.linux-cachyos-latest-lto-x86_64-v3;
    homeManager.enable = true;
    enableMirrorSubstituter = true;
    enableCompatLibraries = true;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "610.57.04";
    sha256_64bit = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
    sha256_aarch64 = "sha256-QCefrMBCmpOwuOyXv1k5Gj0iB2CYlPgnG3JToUw/j54=";
    openSha256 = "sha256-rQHOOOY4KL92Ww3KDwh+j4eGU7oNAH8LutZC5wmFnPo=";
    settingsSha256 = "sha256-ZEMo8I8Zc2Tq6RVDNYpAH+f094dUaZiBqO+5f6lIjRI=";
    persistencedSha256 = "sha256-aXmD2VY1RLlgAnlHhOUMWzvMyhI6JTClcFLm4imF/mA=";
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
