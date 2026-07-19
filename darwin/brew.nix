_: {
  homebrew = {
    enable = true;
    enableFishIntegration = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
      upgrade = false;
    };

    masApps = {
      WeChat = 836500024;
      QQ = 451108668;
      Infuse = 1136220934;
      ESTKme = 6738199509;
    };

    taps = [
      {
        name = "AnInsomniacy/motrix-next";
        trusted = true;
      }
      {
        name = "Renna42/tap";
        trusted = true;
      }
    ];
    brews = [];
    casks = [
      # keep-sorted start case=no
      "AnInsomniacy/motrix-next/motrix-next"
      "arch1t3cht-aegisub"
      "audacity"
      "balenaetcher"
      "betterdisplay"
      "bitwarden"
      "coteditor"
      "dbeaver-community"
      "discord"
      "element"
      "firefox"
      "font-harmonyos-sans-sc"
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
      "karabiner-elements"
      "kitty"
      "launchcontrol"
      "localsend"
      "lulu"
      "maccy"
      "mediainfo"
      "mkvtoolnix-app"
      "musicbrainz-picard"
      "obs"
      "obsidian"
      "orbstack"
      "Renna42/tap/angry-ip-scanner"
      "Renna42/tap/c0re100-qbittorrent"
      "Renna42/tap/imhex"
      "Renna42/tap/makemkv"
      "Renna42/tap/orcastudio"
      "Renna42/tap/xld"
      "reqable"
      "shichizip-zs"
      "shottr"
      "squirrel-app"
      "steam"
      "tailscale-app"
      "teamspeak-client"
      "tinymediamanager"
      "typora"
      "uninstallpkg"
      "utm@beta"
      "vnc-viewer"
      "wireshark-app"
      "yubico-authenticator"
      # keep-sorted end
    ];
  };
}
