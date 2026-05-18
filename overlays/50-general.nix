_: final: prev: {
  # keep-sorted start block=yes
  mpv-unwrapped = prev.mpv-unwrapped.override {
    inherit (final.nur-xddxdd.lantianCustomized) ffmpeg;
  };
  # keep-sorted end
}
