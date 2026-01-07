{lib, ...}: {
  xdg.configFile."fcitx5".source = lib.mkForce ./configs;
}
