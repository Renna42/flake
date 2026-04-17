{pkgs, ...}: {
  home.packages = with pkgs; [
    # keep-sorted start
    _7zip-zstd-rar
    brotli
    bzip2_1_1
    cpio
    gnutar
    gzip
    lz4
    rar
    unrar
    unzipNLS
    wimlib
    xz
    zip
    zstd
    # keep-sorted end
  ];
}
