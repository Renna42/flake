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
      # keep-sorted start block=yes
      "bambu-studio"
      "bitwarden"
      "claude-code"
      "coteditor"
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
      "notion"
      "obs"
      "orbstack"
      "reqable"
      "shottr"
      "siyuan"
      "tailscale-app"
      "telegram-desktop"
      "tinymediamanager"
      "typora"
      "utm@beta"
      "zed"
      # keep-sorted end
    ];
  };
}
