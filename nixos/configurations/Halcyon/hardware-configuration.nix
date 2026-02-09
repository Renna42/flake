{
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
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
  boot.kernelParams = [
    # Do not generate NIC names based on PCIe addresses (e.g. enp1s0, useless for VPS)
    # Generate names based on orders (e.g. eth0)
    "net.ifnames=0"
  ];

  networking.useDHCP = false;
  networking.interfaces.eth0 = {
    ipv4.addresses = [
      {
        address = "43.247.132.122";
        prefixLength = 24;
      }
    ];
    ipv6.addresses = [
      {
        address = "2401:2660:1001:028b:b650:5b52:a3b2:8760";
        prefixLength = 64;
      }
      {
        address = "2401:2660:1001:029c:1af3:a8b6:cf82:e156";
        prefixLength = 64;
      }
    ];
  };
  networking.defaultGateway = "43.247.132.1";
  networking.nameservers = ["1.1.1.1"];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
