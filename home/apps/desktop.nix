{pkgs, ...}: {
  imports = [
    ./firefox
    ./vscode
    ./kitty
    ./idapro
    ./yubikey
    ./wakatime
  ];

  home.packages = with pkgs; [
    localsend
    bitwarden-desktop
    imhex
    dbeaver-bin
    tenacity
    mediainfo
  ];
}
