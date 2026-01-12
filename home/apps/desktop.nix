{pkgs, ...}: {
  imports = [
    ./firefox
    ./vscode
    ./kitty
    ./idapro
    ./yubikey
  ];

  home.packages = with pkgs; [
    localsend
    bitwarden-desktop
    imhex
    dbeaver-bin
    tenacity
  ];
}
