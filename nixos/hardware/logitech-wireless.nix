{config, ...}: {
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = config.services.displayManager.sessionPackages != [];
  };
}
