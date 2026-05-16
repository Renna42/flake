{
  inputs,
  lib,
  pkgs,
  overlays,
  ...
}: let
  allowedUsers = [
    "@admin"
    "root"
  ];
in {
  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    daemonProcessType = "Background";
    daemonIOLowPriority = true;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    settings = {
      accept-flake-config = true;
      allowed-users = lib.mkForce allowedUsers;
      auto-optimise-store = true;
      connect-timeout = 5;
      # download-buffer-size = 1024 * 1024 * 1024;  # Removed in Lix
      experimental-features = lib.mkForce "nix-command flakes";
      extra-experimental-features = lib.mkForce "nix-command flakes";
      fallback = true;
      keep-going = true;
      keep-outputs = true;
      log-lines = 25;
      max-free = 1000 * 1000 * 1000;
      min-free = 128 * 1000 * 1000;
      trusted-users = allowedUsers;
      warn-dirty = false;
      use-xdg-base-directories = true;

      # # Determinate Nix specific
      # eval-cores = 0;
      # max-jobs = "auto";
      # lazy-trees = true;

      substituters = [
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
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

    channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  nixpkgs = {
    inherit overlays;
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  };
}
