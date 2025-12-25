{
  assetsPath,
  pkgs,
  osConfig,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = osConfig.stylix.base16Scheme;
    polarity = "dark";
    opacity.terminal = 0.8;
    image = "${assetsPath}/wallpapers/106096441_p7.png";
    targets.qt.platform = "qtct";
    fonts = {
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
}
