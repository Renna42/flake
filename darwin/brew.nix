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
      Wechat = 836500024;
      QQ = 451108668;
    };

    taps = [];

    brews = [];

    casks = [
      "firefox"
      "google-chrome"
      "kitty"
      "vscodium"
      "ayugram"
      "orbstack"
      "font-fira-code-nerd-font"
      "font-maple-mono-nf-cn"
      "alt-tab"
      "maccy"
      "shottr"
      "dbeaver-community"
      "jordanbaird-ice"
      "stats"
      "typora"
      "tailscale-app"
      "siyuan"
      "notion"
      "telegram-desktop"
      "bitwarden"
      "karabiner-elements"
      "launchcontrol"
      "mos"
    ];
  };
}
