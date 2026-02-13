{
  assetsPath,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./base.nix
    ./nix.nix
    ./theme.nix

    # keep-sorted start block=yes
    ./apps/chromium
    ./apps/claude
    ./apps/fcitx5
    ./apps/firefox
    ./apps/idapro
    ./apps/kitty
    ./apps/obs-studio
    ./apps/vscode
    ./apps/wakatime
    ./apps/yubikey
    ./apps/zed
    # keep-sorted end

    ./apps/develop.nix
    ./apps/game.nix
    ./apps/shell-utils.nix
  ];

  home = {
    packages = with pkgs; [
      # keep-sorted start block=yes case=no
      _64gram
      bitwarden-desktop
      cider-2
      dbeaver-bin
      imhex
      kdePackages.kleopatra
      localsend
      mediainfo-gui
      motrix
      openscreen
      podman-desktop
      realvnc-vnc-viewer
      siyuan
      tenacity
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
      # GTK_IM_MODULE = "fcitx";
      # QT_IM_MODULE = "fcitx";
      # SDL_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      GLFW_IM_MODULE = "ibus";
      # misc
      "_JAVA_AWT_WM_NONREPARENTING" = "1";
      "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
      "QT_QPA_PLATFORM" = "wayland";
      "SDL_VIDEODRIVER" = "wayland";
      "GDK_BACKEND" = "wayland";
      "CLUTTER_BACKEND" = "wayland";
      "XDG_SESSION_TYPE" = "wayland";
    };

    file.".face.icon".source = "${assetsPath}/${username}.png";
  };

  xdg.configFile."containers/registries.conf".text = ''
    [registries.search]
    registries = ['docker.io']
  '';

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
}
