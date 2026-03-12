{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../nixos/roles/server
    ../../nixos/disk-layouts/xfs-efi-compat.nix
  ];

  boot.supportedFilesystems = ["ntfs"];
  boot.extraModulePackages = with pkgs; [
    flakePackages.linuxPackages_xanmod_latest.smifb2
  ];
  boot.kernelModules = [
    "smifb"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
