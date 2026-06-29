{
  inputs,
  lib,
  overlays,
  ...
}: let
  allowedUsers = [
    "@admin"
    "root"
  ];
in {
  nix = {
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
      download-buffer-size = 1024 * 1024 * 1024;
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
      # lazy-trees = true;

      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];
      # Disable the built-in flake registry to speed up evaluation
      flake-registry = "";
    };

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
