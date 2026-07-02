{
  config,
  lib,
  pkgs,
  ...
}: let
  realtimeLimitUS = 5000000;
in {
  imports = [
    ./pipewire-latency-adjust.nix
    ./pipewire-rtprio.nix
    ./wireplumber-bluez.nix
  ];

  # Enable OSS emulation
  boot.kernelModules = ["snd_pcm_oss"];

  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0 power_save_controller=N
  '';

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

    extraConfig.pipewire = {
      "10-sample-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            192000
            384000
            768000
          ];

          "default.clock.quantum" = 32;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 32;
        };
      };
    };
  };

  systemd.services.pipewire-auto-start = {
    description = "Keep PipeWire running";
    after = ["pipewire.socket"];
    requires = ["pipewire.socket"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.netcat-openbsd} -U /run/pipewire/pipewire-0";
      User = "pipewire";
      Group = "pipewire";
      Restart = "always";
      RestartSec = "3";
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
