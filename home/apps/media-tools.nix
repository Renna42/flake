{pkgs, ...}: {
  home.packages = with pkgs;
    [
      (ffmpeg-full.override {withUnfree = true;})

      # keep-sorted start case=no
      alac
      bchunk
      cuetools
      flac
      flakePackages.truehdd
      id3v2
      shntool
      wavpack
      yt-dlp
      # keep-sorted end
    ]
    ++ (
      if pkgs.stdenv.isLinux
      then [
        mkvtoolnix
        picard
      ]
      else [
        mkvtoolnix-cli
      ]
    );
}
