{pkgs, ...}: {
  home.packages = with pkgs; [
    android-tools
    payload-dumper-go
    scrcpy
  ];
}
