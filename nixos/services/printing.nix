{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  environment.systemPackages = with pkgs; [
    system-config-printer
  ];
}
