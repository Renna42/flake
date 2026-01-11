{
  assetsPath,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../../base.nix
    ../../../stylix.nix

    ../../../apps/fcitx5
    ../../../apps/desktop.nix
    ../../../apps/develop.nix
    ../../../apps/shell-utils.nix
    ../../../apps/game.nix
  ];

  home = {
    packages = with pkgs; [
      _64gram
      vlc
      siyuan
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
      GLFW_IM_MODULE = "ibus"; # 有些程序通过 ibus 协议连接 fcitx
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
