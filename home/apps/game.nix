{
  lib,
  pkgs,
  osConfig,
  platform,
  ...
}: {
  home.packages = with pkgs; [
    prismlauncher
    osu-lazer-bin
    ryubing
  ];

  programs.lutris = lib.mkIf platform.isLinux {
    enable = true;
    steamPackage = osConfig.programs.steam.package;
    defaultWinePackage = pkgs.flakePackages.dwproton-bin;
    protonPackages = [
      pkgs.flakePackages.dwproton-bin
    ];
    extraPackages = with pkgs; [
      mangohud
      winetricks
      gamescope
      gamemode
      mesa-demos # for glxinfo
    ];
  };
  # Lutris runtime has some incompatible libraries
  home.sessionVariables.LUTRIS_RUNTIME = "0";
}
