{
  config,
  inputs,
  lib,
  pkgs,
  overlays,
  ...
}: let
  allowedUsers = [
    "@wheel"
    "root"
  ];
in {
  options = {
    renna.enableMirrorSubstituter = lib.mkEnableOption "Enable mirror for cache.nixos.org";
  };

  config = {
    services.angrr = {
      enable = true;
      settings = {
        temporary-root-policies = {
          direnv = {
            path-regex = "/\\.direnv/";
            period = "14d";
          };
          result = {
            path-regex = "/result[^/]*$";
            period = "3d";
          };
        };
        profile-policies = {
          system = {
            profile-paths = ["/nix/var/nix/profiles/system"];
            keep-since = "14d";
            keep-latest-n = 5;
            keep-booted-system = true;
            keep-current-system = true;
          };
          user = {
            enable = false; # Policies can be individually disabled
            profile-paths = [
              "~/.local/state/nix/profiles/profile"
              "/nix/var/nix/profiles/per-user/root/profile"
            ];
            keep-since = "1d";
            keep-latest-n = 1;
          };
        };
      };
    };

    nix = {
      package = pkgs.lixPackageSets.latest.lix;

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
        # download-buffer-size = 1024 * 1024 * 1024;  # Removed in Lix
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
        # max-jobs = "auto";
        # lazy-trees = true;

        substituters = lib.mkIf config.renna.enableMirrorSubstituter [
          "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://mirrors.ustc.edu.cn/nix-channels/store"
        ];
        # Disable the built-in flake registry to speed up evaluation
        flake-registry = "";
      };
      # This is important. It locks nixpkgs registry used in nix shell
      # to the same of flakes. Saves time.
      registry =
        {
          pkgs.flake = inputs.self;
        }
        // lib.mapAttrs (_: flakes: {flake = flakes;}) inputs;

      # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
      channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    };

    nixpkgs = {
      inherit overlays;
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
        cudaSupport = config.hardware.nvidia.enabled;
        permittedInsecurePackages = [
          "ventoy-1.1.10"
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
