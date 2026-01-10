_: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
      upgrade = true;
    };
    caskArgs = {
      no_quarantine = true;
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
      "font-fira-code-nerd-font"
      "font-maple-mono-nf-cn"
      "maccy"
      "dbeaver-community"
      "jordanbaird-ice"
      "typora"
      "tailscale-app"
      "siyuan"
      "notion"
      "ayugram"
      "bitwarden"
      "mos"
      "gpg-suite"
      "iina"
      "element"
      "keka"
      "localsend"
      "imhex"
      "coteditor"
    ];
  };
}
