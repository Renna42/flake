{pkgs, ...}: {
  imports = [
    ./stylix.nix

    ./apps/desktop.nix
    ./apps/develop.nix
    ./apps/shell-utils.nix
  ];

  home.packages = with pkgs; [
    iina
    ice-bar
    notion-app
    maccy
    mos
  ];
}
