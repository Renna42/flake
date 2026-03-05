_: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
      upgrade = true;
    };

    masApps = {
      WeChat = 836500024;
      QQ = 451108668;
      Infuse = 1136220934;
    };

    taps = [
      "Renna42/tap"
    ];
    brews = [
      "nexttrace"
    ];
    casks = [
      # keep-sorted start
      "Renna42/tap/ayugram"
      "Renna42/tap/imhex"
      "alienator88-sentinel"
      "audacity"
      "bambu-studio"
      "bitwarden"
      "clash-verge-rev"
      "coteditor"
      "dbeaver"
      "discord"
      "element"
      "firefox"
      "google-chrome"
      "gpg-suite"
      "handbrake-app"
      "iina"
      "inkscape"
      "input-source-pro"
      "jetbrains-toolbox"
      "jordanbaird-ice"
      "karabiner-elements"
      "keka"
      "kekaexternalhelper"
      "kitty"
      "launchcontrol"
      "localsend"
      "lulu"
      "maccy"
      "mediainfo"
      "mkvtoolnix-app"
      "mos@beta"
      "motrix"
      "obs"
      "orbstack"
      "reqable"
      "shottr"
      "siyuan"
      "tailscale-app"
      "teamspeak-client"
      "tinymediamanager"
      "typora"
      "utm@beta"
      "vnc-viewer"
      "zed"
      # keep-sorted end
    ];
  };
}
