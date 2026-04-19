{pkgs, ...}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    platformOptimizations.enable = true;
    extraCompatPackages = with pkgs; [
      dwproton-bin
    ];
    fontPackages = with pkgs; [
      source-han-sans
    ];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };
    };
  };

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  environment.systemPackages = with pkgs; [
    lutris
  ];
}
