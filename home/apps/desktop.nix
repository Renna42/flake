{
  lib,
  pkgs,
  platform,
  ...
}: {
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

  home.packages = with pkgs;
    [
      imhex
      dbeaver-bin
      tenacity
      openscreen
    ]
    ++ lib.optionals (!platform.isDarwin) [
      localsend
      bitwarden-desktop
      mediainfo
      realvnc-vnc-viewer
      motrix
      cider-2
    ];
}
