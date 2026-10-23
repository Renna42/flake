{
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages =
    (with pkgs; [
      # keep-sorted start case=no
      alac
      bchunk
      chromaprint
      cuetools
      dovi-tool
      ffsubsync
      flac
      gpac
      hdr10plus_tool
      id3v2
      lame
      libwebp
      n-m3u8dl-re
      renna.ffmpeg-renna-full
      renna.harletty-bridge
      renna.ilass
      renna.justonecacophony
      renna.lapse-silero
      shntool
      wavpack
      yt-dlp
      # keep-sorted end
    ])
    ++ (
      with unstablePkgs;
        [
          rsgain
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
        )
    );
}
