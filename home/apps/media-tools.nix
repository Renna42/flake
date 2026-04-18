{pkgs, ...}: {
  home.packages = with pkgs; [
    (ffmpeg-full.override {withUnfree = true;})

    # keep-sorted start
    alac
    bchunk
    cuetools
    flac
    id3v2
    shntool
    wavpack
    yt-dlp
    # keep-sorted end
  ];
}
