{
  lib,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ../modules/nixos
    ../modules/roles/desktop
    ../modules/desktop/greetd.nix
    ../modules/desktop/suites/plasma.nix
    ../modules/hardware/nvidia.nix
    ../modules/hardware/intel-gfx.nix
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/tpm.nix
    ../modules/hardware/xpad.nix
    ../modules/services/kmscon.nix
    ../modules/services/mdns.nix
    ../modules/services/proxy.nix
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
