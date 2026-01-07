{
  lib,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ../nixos/common
    ../nixos/roles/desktop
    # ../nixos/gui/suites/hyprland.nix
    ../nixos/gui/suites/plasma.nix
    ../nixos/hardware/nvidia.nix
    ../nixos/hardware/intel-gfx.nix
    ../nixos/hardware/bluetooth.nix
    ../nixos/hardware/tpm.nix
    ../nixos/hardware/xpad.nix
    ../nixos/services/kmscon.nix
    ../nixos/services/mdns.nix
    ../nixos/services/proxy.nix
    ../nixos/users/renna.nix
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

  izmn = {
    homeManager = {
      modules = [
        ../home/linux-desktop.nix
        ../home/apps/develop.nix
        ../home/apps/shell-utils.nix
      ];
    };
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
