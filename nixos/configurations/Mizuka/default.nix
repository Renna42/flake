{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./epson_l8168.nix

    ../../roles/desktop
    # ../../gui/suites/hyprland.nix
    ../../gui/suites/plasma.nix
    ../../gui/game.nix

    ../../hardware/nvidia.nix
    ../../hardware/intel-gfx.nix
    ../../hardware/bluetooth.nix
    ../../hardware/tpm.nix
    ../../hardware/xpad.nix
    ../../hardware/logitech-wireless.nix

    ../../services/kmscon.nix
    ../../services/mdns.nix
    ../../services/proxy.nix
    ../../services/fprintd.nix
    ../../services/printing.nix
    ../../services/podman.nix
    ../../services/libvirt.nix
    ../../services/nix-cache-proxy.nix

    ../../programs/wine.nix

    ../../users/renna.nix
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
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
  };

  networking.hostName = hostname;

  renna = {
    homeManager.enable = true;
    enableMirrorSubstituter = true;
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
