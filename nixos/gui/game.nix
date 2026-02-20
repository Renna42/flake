{pkgs, ...}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    extraCompatPackages = with pkgs; [
      flakePackages.dwproton-bin
    ];
    extest.enable = true;
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

  hardware.steam-hardware.enable = true;

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  environment.systemPackages = with pkgs; [
    lutris
  ];
}
