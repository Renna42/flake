{unstablePkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    package = unstablePkgs.obs-studio.override {
      cudaSupport = true;
    };
    plugins = with unstablePkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
