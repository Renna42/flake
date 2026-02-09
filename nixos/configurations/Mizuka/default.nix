{
  lib,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../roles/desktop
    # ../../gui/suites/hyprland.nix
    ../../gui/suites/plasma.nix
    ../../gui/game.nix

    ../../hardware/nvidia.nix
    ../../hardware/intel-gfx.nix
    ../../hardware/bluetooth.nix
    ../../hardware/tpm.nix
    ../../hardware/xpad.nix
    ../../hardware/printers/epson_l8168.nix

    ../../services/kmscon.nix
    ../../services/mdns.nix
    ../../services/proxy.nix
    ../../services/fprintd.nix
    ../../services/printing.nix
    ../../services/podman.nix
    ../../services/libvirt.nix
    ../../services/wine.nix
    ../../services/obs-cam.nix
    ../../services/nexttrace.nix

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
        consoleMode = "2";
        edk2-uefi-shell.enable = true;
        configurationLimit = lib.mkDefault 10;
      };
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  };

  networking.hostName = hostname;

  renna = {
    homeManager.enable = true;
    useMirrorRepos = true;
  };

  boot.binfmt = {
    emulatedSystems = ["aarch64-linux"];
    preferStaticEmulators = true; # required to work with podman
  };
}
