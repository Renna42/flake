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

  environment.systemPackages = with pkgs; [
    lutris
    steam-devices-udev-rules
  ];
}
