{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_24
    corepack_24
    go
    uv
    python313

    subversionClient
    mercurial

    nixd
    alejandra
  ];
}
