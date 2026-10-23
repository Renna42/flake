{
  lib,
  stdenv,
  ffmpeg_9,
  ffmpegVariant ? "small",
}:
(
  ffmpeg_9.override (
    {
      inherit ffmpegVariant;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      withRtmp = true;
      withUnfree = true;
    }
  )
).overrideAttrs (old: {
  patches =
    (old.patches or [])
    ++ [
      # https://github.com/nilaoda/Blog/discussions/81
      # https://gitee.com/openharmony/third_party_ffmpeg/pulls/49/files
      ../patches/ffmpeg-libavcodec-av3a.patch
      # https://gitee.com/openharmony/third_party_ffmpeg/pulls/128/files
      ../patches/ffmpeg-libavformat-av3a.patch
    ];

  doCheck = false;
  doInstallCheck = false;
})
