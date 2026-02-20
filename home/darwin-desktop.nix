{
  assetsPath,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
    ./nix.nix
    ./theme.nix

    # keep-sorted start block=yes
    ./apps/firefox
    ./apps/idapro
    ./apps/kitty
    ./apps/syncthing
    ./apps/vscode
    ./apps/wakatime
    ./apps/yubikey
    # keep-sorted end

    ./apps/develop.nix
    ./apps/shell-utils.nix
  ];

  renna.syncthing = {
    captureone = true;
  };

  home = {
    packages = with pkgs; [
      # keep-sorted start block=yes case=no
      dbeaver-bin
      imhex
      openscreen
      tenacity
      # keep-sorted end
    ];

    file."Library/Application Support/abnerworks.Typora/themes/mdmdt.css".source = "${assetsPath}/mdmdt.css";
  };
}
