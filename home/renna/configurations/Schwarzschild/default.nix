{
  assetsPath,
  pkgs,
  ...
}: {
  imports = [
    ../../../base.nix
    ../../../nix.nix
    ../../../theme.nix

    ../../../apps/desktop.nix
    ../../../apps/develop.nix
    ../../../apps/shell-utils.nix
  ];

  home = {
    packages = with pkgs; [
      iina
      ice-bar
      notion-app
      maccy
      mos
    ];
    file."Library/Application Support/abnerworks.Typora/themes/mdmdt.css".source = "${assetsPath}/mdmdt.css";
  };
}
