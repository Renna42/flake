{
  config,
  lib,
  ...
}: let
  cfg = config.renna.pipewire.latencyAdjust;

  latencyAdjustOptions = _: {
    options = {
      delay = lib.mkOption {
        type = lib.types.number;
        default = {};
      };
      position = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "FL,FR";
      };
    };
  };
in {
  options = {
    renna.pipewire.latencyAdjust = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule latencyAdjustOptions);
      default = {};
    };
  };

  config.services.pipewire.extraConfig.pipewire = lib.mkIf (cfg != {}) {
    "49-latency-adjust.conf" = {
      "context.modules" =
        lib.mapAttrsToList (n: v: {
          name = "libpipewire-module-loopback";
          args = {
            "node.name" = "latency_adjust_${n}";
            "node.description" = "Latency Adjustment for ${n}";
            "target.delay.sec" = v.delay;
            "capture.props" = {
              "node.name" = "latency_adjust.${n}";
              "media.class" = "Audio/Sink";
            };
            "playback.props" =
              {
                "node.name" = "playback.latency_adjust.${n}";
                "media.class" = "Stream/Output/Audio";
                "target.object" = n;
              }
              // lib.optionalAttrs (v.position != null) {
                "audio.position" = v.position;
              };
          };
        })
        cfg;
    };
  };
}
