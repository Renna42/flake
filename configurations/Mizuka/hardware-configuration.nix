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
    supportedFilesystems = ["ntfs"];
  };

  # To make sops-nix happy
  fileSystems."/home".neededForBoot = true;

  services.pipewire.wireplumber.extraConfig."fosi-audio-zh3" = {
    "monitor.alsa.rules" = [
      {
        matches = [{"node.name" = "alsa_output.usb-Fosi_Fosi_Audio_ZH3-00.analog-stereo";}];
        actions.update-props = {
          "audio.format" = "S32LE";
          "audio.rate" = 768000;
        };
      }
    ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
