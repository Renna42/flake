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
      WeChat = 836500024;
      QQ = 451108668;
      Infuse = 1136220934;
    };

    taps = [];
    brews = [];
    casks = [
      "font-fira-code-nerd-font"
      "font-maple-mono-nf-cn"
      "typora"
      "tailscale-app"
      "siyuan"
      "gpg-suite"
      "element"
      "coteditor"
    ];
  };
}
