{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc-ut
        fcitx5-pinyin-zhwiki
        fcitx5-pinyin-moegirl
        kdePackages.fcitx5-chinese-addons
        kdePackages.fcitx5-qt
      ];
    };
  };
}
