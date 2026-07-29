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
      url = "https://i.pixiv.cat/img-original/img/2023/12/21/19/24/55/114414442_p0.png";
      hash = "sha256-a2AULPcPcfrpe2SjHk0e4nA1+qGkzFQUDjl33TjqDHo=";
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
      WALLPAPER_PATH="${config.stylix.image}"

      if [ ! -f "$WALLPAPER_PATH" ]; then
        echo "Wallpaper file $WALLPAPER_PATH not found."
        exit 1
      fi

      echo "Applying wallpaper to all macOS screens via Swift API..."

      ${pkgs.swift}/bin/swift - "$WALLPAPER_PATH" <<'SWIFT' || /usr/bin/osascript <<EOF
        import AppKit

        let args = CommandLine.arguments
        if args.count > 1 {
            let path = args[1]
            let url = URL(fileURLWithPath: path)
            let workspace = NSWorkspace.shared
            for screen in NSScreen.screens {
                do {
                    try workspace.setWallpaperImageURL(url, for: screen, options: [:])
                } catch {
                    print("Failed to set wallpaper for a screen: \(error)")
                }
            }
        }
      SWIFT
        tell application "System Events"
          tell every desktop
            set picture to "$WALLPAPER_PATH"
          end tell
        end tell
      EOF
    '';
  };
}
