{pkgs, ...}: {
  services = {
    displayManager.plasma-login-manager.enable = true;
    desktopManager.plasma6.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
    discover
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
