{
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
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
      libwebp
      rsgain
      shntool
      truehdd
      unstablePkgs.yt-dlp
      wavpack
      # keep-sorted end
    ])
    ++ (
      with unstablePkgs;
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
