{
  pkgs,
  unstablePkgs,
  ...
}: {
  renna.homeManager = {
    enable = true;
    modules = [
      # keep-sorted start
      ../../home/apps/archives
      ../../home/apps/chromium
      ../../home/apps/develop
      ../../home/apps/develop/c-family.nix
      ../../home/apps/develop/nodejs.nix
      ../../home/apps/develop/python.nix
      ../../home/apps/discord
      ../../home/apps/easyeffects
      ../../home/apps/element
      ../../home/apps/fcitx5
      ../../home/apps/firefox
      ../../home/apps/kitty
      ../../home/apps/mpv
      ../../home/apps/obs-studio
      ../../home/apps/obsidian
      ../../home/apps/rime
      ../../home/apps/syncthing
      ../../home/apps/vscodium
      ../../home/apps/wakatime
      ../../home/apps/yubikey
      # keep-sorted end

      ../../home/apps/android.nix
      ../../home/apps/game.nix
      ../../home/apps/media-tools.nix
      ../../home/apps/shell-utils.nix

      {
        renna.syncthing.rime = true;
        services.tailscale-systray.enable = true;
        home.packages = with pkgs;
          [
            # keep-sorted start case=no
            angryipscanner
            audacity
            ayugram-desktop
            dbeaver-bin
            dejavu_fonts
            imhex
            kdePackages.kleopatra
            krita
            localsend
            makemkv
            mediainfo
            motrix-next
            qbittorrent-enhanced
            renna.aegisub-arch1t3cht
            renna.exactaudiocopy
            roomeqwizard
            strawberry
            teamspeak6-client
            ventoy-full
            vlc
            # keep-sorted end
          ]
          ++ (with unstablePkgs; [
            # keep-sorted start case=no
            nur-xddxdd.wechat-uos-sandboxed
            podman-desktop
            qq
            splayer-next
            # keep-sorted end
          ]);
      }
    ];
  };
}
