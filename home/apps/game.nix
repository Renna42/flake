{
  pkgs,
  osConfig,
  ...
}: {
  home.packages = with pkgs; [
    # keep-sorted start
    adwsteamgtk
    osu-lazer-bin
    prismlauncher
    ryubing
    # keep-sorted end
  ];

  programs.lutris = {
    enable = true;
    steamPackage = osConfig.programs.steam.package;
    defaultWinePackage = pkgs.dwproton-bin;
    protonPackages = [
      pkgs.dwproton-bin
    ];
    extraPackages = with pkgs; [
      mangohud
    ];
  };
  # Lutris runtime has some incompatible libraries
  home.sessionVariables.LUTRIS_RUNTIME = "0";
}
