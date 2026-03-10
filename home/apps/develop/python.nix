{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    pdm
    poetry
    (python313.withPackages (python-pkgs:
      with python-pkgs; [
        ipython
        requests
        httpx
      ]))
  ];
}
