{
  config,
  inputs,
  lib,
  pkgs,
  secretsPath,
  overlays,
  ...
}: {
  sops = {
    secrets.nix_access_tokens = {
      sopsFile = "${secretsPath}/nix-daemon-auth.yaml";
    };
    templates."nix-github-tokens".content = ''
      access-tokens = ${config.sops.placeholder.nix_access_tokens}
    '';
  };

  nix = {
    package = pkgs.nix;
    settings = {
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
      warn-dirty = false;
      use-xdg-base-directories = true;
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

    extraOptions = ''
      !include ${config.sops.templates."nix-github-tokens".path}
    '';
  };

  nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
    config.allowDeprecatedx86_64Darwin = true;
  };
}
