{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wineWow64Packages.waylandFull
    wineWow64Packages.fonts
    winetricks
  ];
}
