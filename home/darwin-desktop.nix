{
  assetsPath,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
    ./nix.nix
    ./theme.nix

    # keep-sorted start
    ./apps/archives
    ./apps/develop
    ./apps/develop/python.nix
    ./apps/firefox
    ./apps/idapro
    ./apps/kitty
    ./apps/syncthing
    ./apps/vscode
    ./apps/wakatime
    ./apps/yubikey
    ./apps/zed
    # keep-sorted end

    ./apps/shell-utils.nix
  ];

  renna.syncthing = {
    captureone = true;
  };

  home = {
    packages = with pkgs; [
      # keep-sorted start
      openscreen
      # keep-sorted end
    ];

    file."Library/Application Support/abnerworks.Typora/themes/mdmdt.css".source = "${assetsPath}/mdmdt.css";
  };
}
