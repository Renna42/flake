{pkgs, ...}: {
  home.packages = with pkgs; [
    # keep-sorted start
    _7zip-zstd-rar
    bzip2_1_1
    gnutar
    gzip
    lz4
    rar
    unrar
    unzipNLS
    xz
    zip
    zstd
    # keep-sorted end
  ];
}
