{
  config,
  inputs,
  lib,
  overlays,
  ...
}: let
  allowedUsers = [
    "@wheel"
    "root"
  ];
  channelsMirror = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels";
in {
  imports = [inputs.angrr.nixosModules.angrr];

  options = {
    renna.enableMirrorSubstituter = lib.mkEnableOption "Enable mirror for cache.nixos.org";
  };

  config = {
    services.angrr = {
      enable = true;
      period = "14d";
    };

    nix = {
      daemonIOSchedClass = lib.mkDefault "idle";
      daemonCPUSchedPolicy = lib.mkDefault "idle";
      daemonIOSchedPriority = 7;

      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
        randomizedDelaySec = "1h";
      };
      nrBuildUsers = 0;
      optimise.automatic = true;
      settings = {
        accept-flake-config = true;
        allowed-users = lib.mkForce allowedUsers;
        auto-allocate-uids = true;
        auto-optimise-store = true;
        build-dir = "/var/cache/nix";
        builders-use-substitutes = true;
        connect-timeout = 5;
        download-buffer-size = 1024 * 1024 * 1024;
        experimental-features = lib.mkForce "nix-command flakes auto-allocate-uids cgroups";
        extra-experimental-features = lib.mkForce "nix-command flakes auto-allocate-uids cgroups";
        fallback = true;
        keep-going = true;
        keep-outputs = true;
        log-lines = 25;
        max-free = 1000 * 1000 * 1000;
        min-free = 128 * 1000 * 1000;
        trusted-users = allowedUsers;
        use-cgroups = true;
        warn-dirty = false;
        use-xdg-base-directories = true;

        # # Determinate Nix specific
        # eval-cores = 0;
        # lazy-trees = true;

        substituters = lib.mkIf config.renna.enableMirrorSubstituter [
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://mirrors.ustc.edu.cn/nix-channels/store"
          "https://cache.nixos.org"
        ];
      };

      channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

      registry = lib.mkIf config.renna.enableMirrorSubstituter {
        nixpkgs-unstable = {
          from = {
            id = "nixpkgs";
            type = "indirect";
            "ref" = "nixos-unstable";
          };
          to = {
            type = "tarball";
            url = "${channelsMirror}/nixpkgs-unstable/nixexprs.tar.zst";
          };
          exact = true;
        };
        nixos-unstable = {
          from = {
            id = "nixpkgs";
            type = "indirect";
            "ref" = "nixos-unstable";
          };
          to = {
            type = "tarball";
            url = "${channelsMirror}/nixos-unstable/nixexprs.tar.zst";
          };
          exact = true;
        };
        nixos-unstable-small = {
          from = {
            id = "nixpkgs";
            type = "indirect";
            "ref" = "nixos-unstable-small";
          };
          to = {
            type = "tarball";
            url = "${channelsMirror}/nixpkgs-unstable-small/nixexprs.tar.zst";
          };
          exact = true;
        };
        "nixos-26.05" = {
          from = {
            id = "nixpkgs";
            type = "indirect";
            "ref" = "nixos-26.05";
          };
          to = {
            type = "tarball";
            url = "${channelsMirror}/nixpkgs-26.05/nixexprs.tar.zst";
          };
          exact = true;
        };
        "nixos-26.05-small" = {
          from = {
            id = "nixpkgs";
            type = "indirect";
            "ref" = "nixos-26.05-small";
          };
          to = {
            type = "tarball";
            url = "${channelsMirror}/nixos-26.05-small/nixexprs.tar.zst";
          };
          exact = true;
        };
        "nixpkgs-26.05-darwin" = {
          from = {
            id = "nixpkgs";
            type = "indirect";
            "ref" = "nixpkgs-26.05-darwin";
          };
          to = {
            type = "tarball";
            url = "${channelsMirror}/nixpkgs-26.05-darwin/nixexprs.tar.zst";
          };
          exact = true;
        };
      };
    };

    nixpkgs = {
      inherit overlays;
      flake.source = inputs.nixpkgs.outPath;
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
        cudaSupport = config.hardware.nvidia.enabled;
        permittedInsecurePackages = [
          "ventoy-1.1.12"
        ];
      };
    };

    systemd.services.nix-daemon = {
      serviceConfig = {
        CacheDirectory = "nix";
        Nice = 19;
        OOMScoreAdjust = 250;
      };
    };

    systemd.timers.nix-gc.timerConfig.Persistent = lib.mkForce "false";

    # always use the daemon, even executed  with root
    environment.variables.NIX_REMOTE = "daemon";
  };
}
