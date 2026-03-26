{pkgs, ...}: {
  imports = [
    ../idapro
  ];

  home.packages = with pkgs; [
    binwalk
  ];
}
