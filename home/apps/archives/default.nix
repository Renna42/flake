{pkgs, ...}: {
  home.packages = with pkgs; [
    # keep-sorted start
    _7zip-zstd-rar
    brotli
    bzip2
    cpio
    gnutar
    gzip
    lz4
    rar
    unzipNLS
    wimlib
    xz
    zip
    zstd
    # keep-sorted end
  ];
}
