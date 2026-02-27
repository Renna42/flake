{
  lib,
  config,
  ...
}: {
  imports = [
    ../../nixos/roles/server
  ];

  boot.loader.limine.efiSupport = false;

  programs = {
    nexttrace.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
