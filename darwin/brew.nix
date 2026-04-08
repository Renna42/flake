_: {
  homebrew = {
    enable = true;
    enableFishIntegration = true;

    onActivation = {
      autoUpdate = true;
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
      "netbirdio/tap"
    ];
    brews = [];
    casks = [
      # keep-sorted start case=no
      "affinity"
      "arch1t3cht-aegisub"
      "audacity"
      "betterdisplay"
      "bitwarden"
      "clash-verge-rev"
      "coteditor"
      "dbeaver-community"
      "discord"
      "element"
      "firefox"
      "font-maple-mono-normal-nl-nf-cn"
      "font-noto-sans"
      "font-noto-sans-cjk"
      "font-noto-serif"
      "font-noto-serif-cjk"
      "font-source-han-sans-vf"
      "font-source-han-serif-vf"
      "font-symbols-only-nerd-font"
      "foobar2000"
      "google-chrome"
      "gpg-suite"
      "handbrake-app"
      "iina"
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
      "musicbrainz-picard"
      "netbird-ui"
      "obs"
      "obsidian"
      "orbstack"
      "orcaslicer"
      "Renna42/tap/angry-ip-scanner"
      "Renna42/tap/ayugram"
      "Renna42/tap/c0re100-qbittorrent"
      "Renna42/tap/imhex"
      "Renna42/tap/xld"
      "reqable"
      "shottr"
      "teamspeak-client"
      "tinymediamanager"
      "typora"
      "utm@beta"
      "vnc-viewer"
      "wireshark-app"
      "zed"
      # keep-sorted end
    ];
  };

  environment.variables = {
    HOMEBREW_NO_ENV_HINTS = "1";
  };
}
