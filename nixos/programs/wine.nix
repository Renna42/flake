{pkgs, ...}: {
  programs.wine = {
    enable = true;
    package = pkgs.wineWow64Packages.waylandFull;
    binfmt = true;
    ntsync = true;
  };

  environment = {
    sessionVariables = {
      PROTON_USE_NTSYNC = 1;
      PROTON_ENABLE_HDR = 1;
    };
    systemPackages = with pkgs; [
      wineWow64Packages.fonts
      winetricks
    ];
  };
}
