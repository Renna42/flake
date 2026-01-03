_: {
  services = {
    desktopManager.plasma6.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
