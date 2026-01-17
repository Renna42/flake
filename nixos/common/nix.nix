{
  config,
  inputs,
  outputs,
  lib,
  secretsPath,
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
      inherit (outputs.nix.settings) substituters;
      narinfo-cache-positive-ttl = 60 * 60 * 24;
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
      warn-dirty = false;
      system-features = [
        "kvm"
        "big-parallel"
      ];
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

    daemonIOSchedClass = lib.mkDefault "idle";
    daemonCPUSchedPolicy = lib.mkDefault "idle";

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    extraOptions = ''
      !include ${config.sops.templates."nix-github-tokens".path}
    '';
  };
}
