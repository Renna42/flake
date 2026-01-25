{pkgs, ...}: {
  imports = [
    ./firefox
    ./vscode
    ./zed
    ./kitty
    ./idapro
    ./yubikey
    ./wakatime
    ./claude
  ];

  home.packages = with pkgs; [
    localsend
    bitwarden-desktop
    imhex
    dbeaver-bin
    tenacity
    mediainfo
    flakePackages.openscreen
  ];
}
