{
  config,
  lib,
  pkgs,
  ...
}: let
  realtimeLimitUS = 5000000;
in {
  # Enable OSS emulation
  boot.kernelModules = ["snd_pcm_oss"];

  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N
  '';
  environment.systemPackages = [
    pkgs.crosspipe
    pkgs.pavucontrol
    pkgs.pulseaudio
  ];

  security.rtkit.enable = true;
  systemd.services.rtkit-daemon.serviceConfig.ExecStart = [
    "" # Override command in rtkit package's service file
    "${pkgs.rtkit}/libexec/rtkit-daemon --rttime-usec-max=${toString realtimeLimitUS}"
  ];

  services.pipewire = {
    enable = true;
    # Fix for ROC sink bug: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/4070
    package = pkgs.pipewire.overrideAttrs (old: {
      patches = (old.patches or []) ++ [../../../patches/pipewire-fix-roc-sink.patch];
    });
    systemWide = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber.enable = true;

    lowLatency = {
      enable = true;
      alsa.enable = true;
    };

    extraConfig.pipewire = {
      "10-sample-rate" = {
        "context.properties" = {
          "default.clock.rate" = 44100;
          "default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            192000
          ];

          # Fix stuttering
          "default.clock.quantum" = 512;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 2048;
        };
      };
    };
  };

  users.users.renna.extraGroups =
    [
      "audio"
    ]
    ++ lib.optionals config.services.pipewire.systemWide ["pipewire"];

  environment.systemPackages = with pkgs; [
    alsa-utils
  ];
}
