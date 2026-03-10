{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    just
    just-lsp

    # We often use adb and fastboot
    android-tools
  ];
}
