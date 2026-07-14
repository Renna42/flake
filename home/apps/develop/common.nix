{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    just
    just-lsp
  ];
}
