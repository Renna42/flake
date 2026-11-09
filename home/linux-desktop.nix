{
  assetsPath,
  username,
  ...
}: {
  imports = [
    ./base.nix
    ./theme.nix
  ];

  home = {
    sessionVariables = {
      "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
      "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
      # enable native Wayland support for most Electron apps
      "ELECTRON_OZONE_PLATFORM_HINT" = "auto";

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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  fonts.fontconfig.enable = true;
}
