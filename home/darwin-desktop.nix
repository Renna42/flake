{assetsPath, ...}: {
  imports = [
    ./base.nix
    ./nix.nix
    ./theme.nix

    # keep-sorted start
    ./apps/archives
    ./apps/develop
    ./apps/develop/c-family.nix
    ./apps/develop/golang.nix
    ./apps/develop/java.nix
    ./apps/develop/nodejs.nix
    ./apps/develop/python.nix
    ./apps/develop/rust.nix
    ./apps/firefox
    ./apps/kitty
    ./apps/obsidian
    ./apps/rime
    ./apps/syncthing
    ./apps/vscodium
    ./apps/wakatime
    ./apps/yubikey
    # keep-sorted end

    ./apps/android.nix
    ./apps/media-tools.nix
    ./apps/shell-utils.nix
  ];

  # man.package default to null on darwin
  programs.man.generateCaches = false;

  renna.syncthing = {
    captureone = true;
    rime = true;
  };

  home = {
    sessionVariables = {
      HOMEBREW_NO_AUTO_UPDATE = "1";
    };
    file = {
      "Library/Application Support/abnerworks.Typora/themes/mdmdt.css".source = "${assetsPath}/mdmdt.css";
      "Library/ColorSync/Profiles/TCL R32U81.icc".source = "${assetsPath}/R32U81.icc";
    };
  };
}
