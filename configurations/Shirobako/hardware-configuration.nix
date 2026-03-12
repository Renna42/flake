{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  disko.devices.disk.main.device = "/dev/sda";

  systemd.network.networks."10-wan" = {
    matchConfig.Name = "eth0";
    networkConfig.IPv6AcceptRA = true;
    address = [
      "10.22.0.211/16"
    ];
    routes = [
      {Gateway = "10.22.0.128";}
    ];
    linkConfig.RequiredForOnline = "routable";
  };

  networking.resolvconf.enable = false;
  environment.etc."resolv.conf".text = ''
    nameserver 10.22.0.128
  '';

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
