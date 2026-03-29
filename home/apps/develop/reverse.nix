{pkgs, ...}: {
  imports = [
    ../idapro
  ];

  home.packages = with pkgs; [
    (binwalk.override {
      enableUnfree = true;
    })
  ];
}
