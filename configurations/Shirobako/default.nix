{lib, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../nixos/roles/server
    ../../nixos/disk-layouts/xfs-efi-compat.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
