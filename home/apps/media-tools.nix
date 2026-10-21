{
  pkgs,
  unstablePkgs,
  ...
}: let
  myffmpeg =
    if pkgs.stdenv.isDarwin
    then pkgs.ffmpeg-full
    else
      (
        (pkgs.ffmpeg-full.override {
          withRtmp = true;
          # only metal is unfree on darwin
          withUnfree = true;
        }).overrideAttrs
        {
          doCheck = false;
          doInstallCheck = false;
        }
      );
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
      myffmpeg
      n-m3u8dl-re
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
