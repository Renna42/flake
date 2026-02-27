{pkgs, ...}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    extraCompatPackages = with pkgs; [
      flakePackages.dwproton-bin
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

  hardware.steam-hardware.enable = true;

  environment.sessionVariables = {
    PROTON_USE_NTSYNC = 1;
    PROTON_ENABLE_HDR = 1;
  };

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  environment.systemPackages = with pkgs; [
    lutris
  ];
}
