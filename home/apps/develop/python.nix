{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    (python313.withPackages (
      python-pkgs:
        with python-pkgs; [
          ipython
          requests
          httpx
        ]
    ))
  ];
}
