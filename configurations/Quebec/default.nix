{
  lib,
  ...
}: {
  imports = [
    ../../nixos/roles/desktop
    ../../nixos/gui/suites/plasma.nix
    ../../nixos/disk-layouts/simple.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  services.qemuGuest.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
