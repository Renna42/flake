{
  unstablePkgs,
  osConfig,
  ...
}: {
  home.packages = with unstablePkgs; [
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
    defaultWinePackage = unstablePkgs.dwproton-bin;
    protonPackages = [
      unstablePkgs.dwproton-bin
    ];
    extraPackages = with unstablePkgs; [
      mangohud
    ];
  };
  # Lutris runtime has some incompatible libraries
  home.sessionVariables.LUTRIS_RUNTIME = "0";
}
