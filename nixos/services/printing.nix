{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
    ];
  };

  environment.systemPackages = with pkgs; [
    system-config-printer
  ];
}
