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
      cuetools
      ffsubsync
      flac
      gpac
      id3v2
      libwebp
      myffmpeg
      renna.ilass
      renna.lapse-silero
      rsgain
      shntool
      truehdd
      wavpack
      yt-dlp
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
