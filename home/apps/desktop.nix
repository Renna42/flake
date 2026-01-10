{pkgs, ...}: {
  imports = [
    ./firefox
    ./vscode
    ./kitty
  ];

  home.packages = with pkgs; [
    _64gram
    localsend
    bitwarden-desktop
    imhex
    dbeaver-bin
  ];
}
