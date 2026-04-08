{
  config,
  inputs,
  lib,
  pkgs,
  overlays,
  ...
}: {
  options = {
    renna.enableMirrorSubstituter = lib.mkEnableOption "Enable mirror for cache.nixos.org";
  };

  config = {
    nix = {
      package = pkgs.nix;
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
        dates = "daily";
      };
      optimise = {
        automatic = true;
        dates = ["03:45"];
      };
      settings = {
        auto-optimise-store = true;
        narinfo-cache-positive-ttl = 60 * 60 * 24;
        allowed-users = [
          "root"
          "@wheel"
        ];
        trusted-users = [
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = lib.mkIf config.renna.enableMirrorSubstituter [
          "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://mirrors.ustc.edu.cn/nix-channels/store"
        ];
        accept-flake-config = true;
        warn-dirty = false;
        use-xdg-base-directories = true;
        builders-use-substitutes = true;

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

      daemonIOSchedClass = lib.mkDefault "idle";
      daemonCPUSchedPolicy = lib.mkDefault "idle";
    };

    nixpkgs = {
      inherit overlays;
      config = {
        allowUnfree = true;
        npmRegistryOverrides = lib.mkIf config.renna.enableMirrorSubstituter {
          "registry.npmjs.org" = "https://registry.npmmirror.com";
        };
        permittedInsecurePackages = [
          "ventoy-qt5-1.1.10"
        ];
      };
    };

    systemd.services.nix-daemon = {
      environment.TMPDIR = "/nix/tmp";

      # put the service in top-level slice
      # so that it's lower than system and user slice overall
      # instead of only being lower in system slice
      serviceConfig.Slice = "-.slice";
    };
    systemd.tmpfiles.rules = [
      "d /nix/tmp 1777 root root 1d"
    ];

    # always use the daemon, even executed  with root
    environment.variables.NIX_REMOTE = "daemon";
  };
}
