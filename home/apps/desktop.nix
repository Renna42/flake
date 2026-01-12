{pkgs, ...}: {
  imports = [
    ./firefox
    ./vscode
    ./kitty
    ./idapro
  ];

  home.packages = with pkgs; [
    localsend
    bitwarden-desktop
    imhex
    dbeaver-bin
    tenacity
  ];
}
