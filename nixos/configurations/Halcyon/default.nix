{
  lib,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../roles/server
    ../../disk-layouts/gpt-bios-compat.nix
  ];

  boot = {
    loader = {
      # Use GRUB2 as the boot loader.
      # We don't use systemd-boot because DogYun uses BIOS legacy boot.
      systemd-boot.enable = lib.mkForce false;
      grub = {
        enable = true;
        efiSupport = false;
        device = "/dev/sda1";
      };
    };
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };

  networking.hostName = hostname;

  disko.devices.disk.main.device = "/dev/sda";
}
