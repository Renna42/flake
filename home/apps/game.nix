{
  pkgs,
  osConfig,
  ...
}: {
  home.packages = with pkgs; [
    prismlauncher
    osu-lazer-bin
    ryubing
  ];

  programs.lutris = {
    enable = true;
    steamPackage = osConfig.programs.steam.package;
    defaultWinePackage = pkgs.flakePackages.dwproton-bin;
    protonPackages = [
      pkgs.flakePackages.dwproton-bin
    ];
    extraPackages = with pkgs; [
      mangohud
    ];
  };
  # Lutris runtime has some incompatible libraries
  home.sessionVariables.LUTRIS_RUNTIME = "0";
}
