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

    taps = [];
    brews = [];
    casks = [
      "typora"
      "tailscale-app"
      "siyuan"
      "ayugram"
      "gpg-suite"
      "element"
      "coteditor"
      "keka"
      "kekaexternalhelper"
      "handbrake-app"
      "lulu"
      "inkscape"
      "reqable"
      "mkvtoolnix-app"
      "mediainfo"
      "jetbrains-toolbox"
      "karabiner-elements"
      "firefox"
      "notion"
      "iina"
      "maccy"
      "mos@beta"
      "jordanbaird-ice"
      "shottr"
      "launchcontrol"
      "google-chrome"
      "input-source-pro"
      "obs"
    ];
  };
}
