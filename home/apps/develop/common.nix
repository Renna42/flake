{pkgs, ...}: {
  home.packages = with pkgs; [
    subversionClient
    mercurial

    devenv
    just
    just-lsp

    # We often use adb and fastboot
    android-tools
  ];
}
