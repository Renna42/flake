{pkgs, ...}: {
  home.packages = with pkgs; [
    # keep-sorted start
    bzip2_1_1
    gnutar
    gzip
    lz4
    p7zip-rar
    unrar
    unzipNLS
    xz
    zip
    zstd
    # keep-sorted end
  ];
}
