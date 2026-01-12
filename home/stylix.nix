{
  assetsPath,
  lib,
  pkgs,
  platform,
  ...
}: let
  commonStylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";
    polarity = "dark";
    opacity.terminal = 0.7;
    image = "${assetsPath}/wallpapers/129665127_p0.png";
    fonts = {
      sizes.terminal = 12;
      serif = {
        package = pkgs.noto-fonts-cjk-serif;
        name = "Noto Serif CJK SC";
      };
      sansSerif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Sans CJK SC";
      };
      monospace = {
        package = pkgs.maple-mono.Normal-NF;
        name = "Maple Mono Normal NF";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
  darwinStylix = lib.recursiveUpdate commonStylix {
    overlays.enable = false;
    fonts.sizes = {
      applications = 10;
    };
  };
  linuxStylix = lib.recursiveUpdate commonStylix {
    targets.qt.platform = "kde";
    icons = {
      enable = true;
      package = pkgs.fluent-icon-theme;
      dark = "Fluent";
      light = "Fluent";
    };
  };
in rec {
  stylix =
    if platform.isDarwin
    then darwinStylix
    else linuxStylix;

  home.activation = lib.mkIf platform.isDarwin {
    "setWallpaper" = lib.hm.dag.entryAfter ["writeBoundary"] ''
      /usr/bin/osascript <<EOF
        tell application "System Events"
          tell every desktop
            set picture to "${stylix.image}"
          end tell
        end tell
      EOF
    '';
  };
}
