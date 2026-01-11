{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_24
    corepack_24
    go
    uv
    (python313.withPackages (python-pkgs:
      with python-pkgs; [
        ipython
        requests
        httpx
      ]))

    subversionClient
    mercurial

    nixd
    alejandra
    just
    devenv
  ];
}
