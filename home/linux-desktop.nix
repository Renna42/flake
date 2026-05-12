{
  assetsPath,
  pkgs,
  username,
  ...
}: let
  toml = pkgs.formats.toml {};
in {
  imports = [
    ./base.nix
    ./nix.nix
    ./theme.nix

    # keep-sorted start
    ./apps/archives
    ./apps/chromium
    ./apps/develop
    ./apps/develop/c-family.nix
    ./apps/develop/nodejs.nix
    ./apps/develop/python.nix
    ./apps/discord
    ./apps/element
    ./apps/fcitx5
    ./apps/firefox
    ./apps/kitty
    ./apps/mpv
    ./apps/obs-studio
    ./apps/obsidian
    ./apps/vscode
    ./apps/wakatime
    ./apps/yubikey
    ./apps/zed
    # keep-sorted end

    ./apps/android.nix
    ./apps/game.nix
    ./apps/shell-utils.nix
  ];

  home = {
    packages = with pkgs; [
      # keep-sorted start case=no
      angryipscanner
      audacity
      ayugram-desktop
      bitwarden-desktop
      cider-2
      dbeaver-bin
      dejavu_fonts
      kdePackages.kleopatra
      krita
      localsend
      makemkv
      mediainfo
      motrix-next
      openscreen
      podman-desktop
      qbittorrent-enhanced
      realvnc-vnc-viewer
      renna.aegisub-arch1t3cht
      teamspeak6-client
      ventoy-full
      vlc
      # keep-sorted end
    ];

    sessionVariables = {
      "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
      "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
      "MOZ_WEBRENDER" = "1";
      # enable native Wayland support for most Electron apps
      "ELECTRON_OZONE_PLATFORM_HINT" = "auto";

      # fcitx5
      GLFW_IM_MODULE = "ibus";
      XMODIFIERS = "@im=fcitx";
      # Not everywhere needs these environments
      # GTK_IM_MODULE = "fcitx";
      # QT_IM_MODULE = "fcitx";
      # SDL_IM_MODULE = "fcitx";

      # misc
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";

      # https://bugreports.qt.io/browse/QTBUG-113574
      "QT_SCALE_FACTOR_ROUNDING_POLICY" = "RoundPreferFloor";

      # Some applications doesnt support wayland
      "QT_QPA_PLATFORM" = "wayland;xcb";
      "SDL_VIDEODRIVER" = "wayland,x11";

      # "GDK_BACKEND" = "wayland"; # GDK 3 & 4 are using wayland defaultly
      "CLUTTER_BACKEND" = "wayland";
      "XDG_SESSION_TYPE" = "wayland";
    };

    file.".face.icon".source = "${assetsPath}/${username}.png";
  };

  services.tailscale-systray.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  xdg.configFile."containers/registries.conf" = {
    source = toml.generate "registries.conf" {
      "registries.search".registries = ["docker.io"];
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        qt6Packages.fcitx5-configtool
        fcitx5-pinyin-zhwiki
        # fcitx5-mozc
        fcitx5-fluent
      ];
    };
  };

  fonts.fontconfig.enable = true;
}
