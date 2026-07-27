{pkgs, ...}: {
  home.packages = with pkgs; [
    uv
    isort
    black
    (python313.withPackages (
      python-pkgs:
        with python-pkgs; [
          # keep-sorted start
          httpx
          ipython
          pycryptodome
          requests
          # keep-sorted end
        ]
    ))
  ];
}
