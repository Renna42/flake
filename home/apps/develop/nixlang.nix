{pkgs, ...}: {
  home.packages = with pkgs; [
    nixd
    alejandra
    nixfmt-tree
    nvfetcher
  ];
}
