{
  pkgs,
  lib,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      source-han-sans
      source-han-serif
      wqy_microhei
      liberation_ttf
      fira-code
      fira-code-symbols
      maple-mono.Normal-NF-CN-unhinted
      nerd-fonts.fira-code
      nerd-fonts.symbols-only
      misans-all
    ];
    enableGhostscriptFonts = true;
    enableDefaultPackages = true;
    fontconfig = {
      antialias = true;
      hinting.enable = false;
      useEmbeddedBitmaps = true;
      defaultFonts = {
        monospace = lib.mkAfter [
          "Maple Mono Normal NF CN"
          "Noto Color Emoji"
        ];
        sansSerif = lib.mkAfter [
          "Noto Sans CJK SC"
          "Symbols Nerd Font Mono"
          "Noto Color Emoji"
        ];
        serif = lib.mkAfter [
          "Noto Serif CJK SC"
          "Symbols Nerd Font Mono"
          "Noto Color Emoji"
        ];
        emoji = ["Noto Color Emoji"];
      };
    };
    fontDir.enable = true;
  };
}
