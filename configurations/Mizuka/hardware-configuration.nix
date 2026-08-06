{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sr_mod"
    ];
    kernelModules = ["kvm-intel"];
    supportedFilesystems = [
      "nfs"
      "ntfs"
    ];
  };

  fileSystems = {
    # To make sops-nix happy
    "/home".neededForBoot = true;

    "/mnt/nas-downloads" = {
      device = "10.22.0.114:/Downloads";
      fsType = "nfs4";
      options = [
        # keep-sorted start
        "_netdev"
        "nconnect=4"
        "nfsvers=4.1"
        "noauto"
        "noresvport"
        "retrans=2"
        "rsize=1048576"
        "timeo=30"
        "wsize=1048576"
        "x-systemd.automount"
        "x-systemd.idle-timeout=10min"
        "x-systemd.mount-timeout=5s"
        # keep-sorted end
      ];
    };

    "/mnt/nas-multimedia" = {
      device = "10.22.0.114:/Multimedia";
      fsType = "nfs4";
      options = [
        # keep-sorted start
        "_netdev"
        "nconnect=4"
        "nfsvers=4.1"
        "noauto"
        "noresvport"
        "retrans=2"
        "rsize=1048576"
        "timeo=30"
        "wsize=1048576"
        "x-systemd.automount"
        "x-systemd.idle-timeout=10min"
        "x-systemd.mount-timeout=5s"
        # keep-sorted end
      ];
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
