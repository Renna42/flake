{
  lib,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ../../roles/desktop
    ../../gui/suites/plasma.nix
    ../../disk-layouts/simple.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = hostname;

  services.qemuGuest.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
