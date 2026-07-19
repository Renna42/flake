{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  commonStylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://i.pixiv.cat/img-original/img/2020/01/24/23/21/01/79075144_p0.jpg";
      hash = "sha256-el4SWrJkQ8aecsRXCJ4S5ZYz1rdGunipQMuC5tgRSK8=";
    };
    polarity = "dark";
    opacity.terminal = 0.8;
    fonts = {
      sizes.terminal = 10;
      serif = {
        package = pkgs.noto-fonts-cjk-serif;
        name = "Noto Serif CJK SC";
      };
      sansSerif = {
        package = pkgs.huaweiPackages.harmonyos-sans-sc-vf;
        name = "HarmonyOS Sans SC";
      };
      monospace = {
        package = pkgs.maple-mono.Normal-NF-CN-unhinted;
        name = "Maple Mono Normal NF CN";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
  darwinStylix = lib.recursiveUpdate commonStylix {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    overlays.enable = false;
    fonts.sizes = {
      applications = 10;
    };
  };
  linuxStylix = lib.recursiveUpdate commonStylix {
    inherit (osConfig.stylix) base16Scheme;
    icons = {
      enable = true;
      package = pkgs.fluent-icon-theme;
      dark = "Fluent";
      light = "Fluent";
    };
  };
in {
  catppuccin = {
    enable = true;
    autoEnable = false;
    flavor = "macchiato";
  };

  stylix =
    if pkgs.stdenv.isDarwin
    then darwinStylix
    else linuxStylix;

  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    "setWallpaper" = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -f "${config.stylix.image}" ]; then
        echo Wallpaper file "${config.stylix.image}" not found.
        exit -1
      fi
      /usr/bin/osascript <<EOF
        tell application "System Events"
          tell every desktop
            set picture to "${config.stylix.image}"
          end tell
        end tell
      EOF
    '';
  };
}
