_: {
  services.fwupd.enable = true;

  systemd.services.fwupd.unitConfig.Before = [""];
}
