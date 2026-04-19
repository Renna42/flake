{
  config,
  lib,
  ...
}: {
  disko.devices = {
    disk.main = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1M";
            type = "EF02"; # for grub MBR
            attributes = [0]; # partition attribute
            priority = 0;
          };
          ESP = {
            size = "512M";
            type = "EF00";
            priority = 1;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0022"
                "dmask=0022"
              ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
              mountOptions = [
                "nosuid"
                "nodev"
              ];
            };
          };
        };
      };
    };
  };

  boot.loader.grub.device = lib.mkDefault config.disko.devices.disk.main.device;
}
