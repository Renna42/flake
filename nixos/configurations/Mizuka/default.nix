{
  lib,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../common
    ../../roles/desktop
    # ../../gui/suites/hyprland.nix
    ../../gui/suites/plasma.nix

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

    ../../users/renna.nix
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
    kernelPackages = pkgs.linuxPackages_zen;
  };

  networking.hostName = hostname;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
