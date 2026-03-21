{pkgs, ...}: {
  services.ddccontrol = {
    enable = true;
    package = pkgs.ddcutil-service;
  };
}
