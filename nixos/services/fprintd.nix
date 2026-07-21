{config, ...}: {
  services.fprintd.enable = true;
  boot.initrd.systemd.packages = [
    config.services.fprintd.package
  ];
}
