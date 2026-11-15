{
  pkgs,
  unstablePkgs,
  ...
}: let
  mysox =
    unstablePkgs.sox.override
    {
      enableLame = true;
    };
in {
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
      loudgain
      mysox
      renna.ffmpeg-renna-full
      renna.harletty-bridge
      renna.ilass
      renna.justonecacophony
      renna.lapse-silero
      renna.orender
      shntool
      wavpack
      yt-dlp
      # keep-sorted end
    ])
    ++ (
      with unstablePkgs;
        [
          rsgain # rsgain 3.8 added support for DSD format
        ]
        ++ (
          if pkgs.stdenv.isLinux
          then [
            mkvtoolnix
            n-m3u8dl-re # building dotnet packages on macOS too slow...
            picard
          ]
          else [
            mkvtoolnix-cli # already installed a GUI version with brew
          ]
        )
    );
}
