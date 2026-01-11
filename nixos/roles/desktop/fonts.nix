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
      localConf = ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
        <fontconfig>
          <!--
            https://caniuse.com/extended-system-fonts
            GitHub uses this for code blocks.
          -->
          <match target="pattern">
            <test qual="any" name="family">
              <string>ui-monospace</string>
            </test>
            <edit name="family" mode="assign" binding="same">
              <string>monospace</string>
            </edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family">
              <string>ui-sans-serif</string>
            </test>
            <edit name="family" mode="assign" binding="same">
              <string>sans-serif</string>
            </edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family">
              <string>ui-serif</string>
            </test>
            <edit name="family" mode="assign" binding="same">
              <string>serif</string>
            </edit>
          </match>

          <match target="pattern">
            <test qual="any" name="family">
              <string>-apple-system</string>
            </test>
            <edit name="family" mode="assign" binding="same">
              <string>sans-serif</string>
            </edit>
          </match>

          <!-- Make MiSans fallbacking to L3 -->
          <alias>
            <family>MiSans</family>
            <prefer>
            <family>MiSans</family>
            <family>MiSans L3</family>
            </prefer>
          </alias>

        </fontconfig>
      '';
    };
    fontDir.enable = true;
  };
}
