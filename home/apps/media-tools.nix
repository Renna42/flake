{pkgs, ...}: {
  home.packages = with pkgs;
    [
      (
        ffmpeg-full.override (
          {
            withUnfree = true;
          }
          // (
            if pkgs.stdenv.isDarwin
            then {
              withCdio = false;
              withChromaprint = false;
              withKvazaar = false;
            }
            else {}
          )
        )
      )

      # keep-sorted start case=no
      alac
      bchunk
      cuetools
      flac
      gpac
      id3v2
      renna.truehdd
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
