{pkgs, ...}: {
  imports = [
    ./stylix.nix

    ./apps/vscode
    ./apps/firefox
    ./apps/kitty
  ];

  home = {
    packages = with pkgs; [
      iina
      ice-bar
      notion-app
      ayugram-desktop
      bitwarden-desktop
      maccy
      keka
      mos
      localsend
      imhex
    ];
  };
}
