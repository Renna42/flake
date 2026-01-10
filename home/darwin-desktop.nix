{pkgs, ...}: {
  imports = [
    ./stylix.nix

    ./apps/vscode
    ./apps/firefox
    ./apps/kitty
  ];

  home.packages = with pkgs; [
    iina
    ice-bar
    notion-app
    bitwarden-desktop
    maccy
    mos
    localsend
    imhex
  ];
}
