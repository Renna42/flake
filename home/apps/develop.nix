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
    rust-bin.stable.latest.default

    subversionClient
    mercurial

    nixd
    alejandra
    just
    just-lsp
    devenv
  ];

  home.sessionVariables = {
    GO111MODULE = "on";
    GOPROXY = "https://goproxy.cn,direct";
  };
}
