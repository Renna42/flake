{
  inputs,
  lib,
  pkgs,
  overlays,
  ...
}: {
  nix = {
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      narinfo-cache-positive-ttl = 60 * 60 * 24;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
      ];
      accept-flake-config = true;
      warn-dirty = false;
      use-xdg-base-directories = true;
      allowed-users = [
        "root"
        "@admin"
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

    gc.automatic = true;
    optimise.automatic = true;

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
