{assetsPath, ...}: {
  imports = [
    ./base.nix
    ./nix.nix
    ./theme.nix

    # keep-sorted start
    ./apps/archives
    ./apps/develop
    ./apps/develop/nodejs.nix
    ./apps/develop/python.nix
    ./apps/develop/reverse.nix
    ./apps/firefox
    ./apps/kitty
    ./apps/obsidian
    ./apps/syncthing
    ./apps/vscode
    ./apps/wakatime
    ./apps/yubikey
    ./apps/zed
    # keep-sorted end

    ./apps/shell-utils.nix
    ./apps/media-tools.nix
  ];

  renna.syncthing = {
    captureone = true;
  };

  home.file."Library/Application Support/abnerworks.Typora/themes/mdmdt.css".source = "${assetsPath}/mdmdt.css";
  home.file."Library/ColorSync/Profiles/TCL R32U81.icc".source = "${assetsPath}/R32U81.icc";
}
