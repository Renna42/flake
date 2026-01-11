{pkgs, ...}: {
  imports = [
    ./firefox
    ./vscode
    ./kitty
  ];

  home.packages = with pkgs; [
    localsend
    bitwarden-desktop
    imhex
    dbeaver-bin
    tenacity
  ];
}
