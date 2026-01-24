{pkgs, ...}: {
  home.packages = with pkgs; [
    prismlauncher
    osu-lazer-bin
  ];

  programs.lutris = {
    enable = true;
    defaultWinePackage = pkgs.proton-ge-bin;
    protonPackages = [
      pkgs.proton-ge-bin
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
