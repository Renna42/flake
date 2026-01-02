{
  inputs,
  lib,
  pkgs,
  users,
  ...
}: {
  nix = {
    # Use Lix
    package = pkgs.lixPackageSets.stable.lix;
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
      narinfo-cache-positive-ttl = 60 * 60 * 24;
      trusted-users =
        [
          "root"
          "@wheel"
        ]
        ++ users;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Mirror
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"

        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

      fallback = true;

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

    daemonIOSchedClass = lib.mkDefault "idle";
    daemonCPUSchedPolicy = lib.mkDefault "idle";

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
