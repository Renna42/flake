{
  assetsPath,
  lib,
  pkgs,
  ...
}: let
  rimeConfig = "${assetsPath}/rime/default.custom.yaml";
  rimeDict = "${assetsPath}/rime/my.dict.yaml";
  rimeIce = "${assetsPath}/rime/rime_ice.custom.yaml";
in {
  home.file =
    {}
    // lib.mkIf pkgs.stdenv.isLinux {
      ".config/ibus/rime/default.custom.yaml".source = rimeConfig;
      ".local/share/fcitx5/rime/default.custom.yaml".source = rimeConfig;
      ".config/ibus/rime/my.dict.yaml".source = rimeDict;
      ".local/share/fcitx5/rime/my.dict.yaml".source = rimeDict;
      ".config/ibus/rime/rime_ice.custom.yaml".source = rimeIce;
      ".local/share/fcitx5/rime/rime_ice.custom.yaml".source = rimeIce;
    }
    // pkgs.stdenv.isDarwin {
      "Library/Rime/default.custom.yaml".source = rimeConfig;
      "Library/Rime/my.dict.yaml".source = rimeDict;
      "Library/Rime/rime_ice.custom.yaml".source = rimeIce;
    };
}
