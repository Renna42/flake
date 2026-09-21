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
      dovi-tool
      ffsubsync
      flac
      gpac
      hdr10plus_tool
      id3v2
      lame
      libwebp
      myffmpeg
      renna.harletty-bridge
      renna.ilass
      renna.lapse-silero
      rsgain
      shntool
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
