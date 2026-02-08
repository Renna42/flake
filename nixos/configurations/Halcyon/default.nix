{
  lib,
  hostname,
  ...
}: {
  imports = [
    ../../roles/server
    ../../disk-layouts/simple.nix
  ];

  networking.hostName = hostname;

  services.qemuGuest.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
