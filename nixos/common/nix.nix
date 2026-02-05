{
  config,
  inputs,
  lib,
  pkgs,
  secretsPath,
  ...
}: {
  options = {
    renna.useMirrorRepos = lib.mkEnableOption "Enable mirror repos";
  };

  config = {
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
        trusted-users = [
          "root"
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = lib.mkIf config.renna.useMirrorRepos [
          "https://mirror.sjtu.edu.cn/nix-channels/store"
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://mirrors.ustc.edu.cn/nix-channels/store"
        ];
        extra-substituters = [
          "https://nix-community.cachix.org"
          "https://cache.garnix.io"
          "https://renna42.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "renna42.cachix.org-1:AqHSiL2lFKYHYJ0U2YFiW1kjItvFMmyyc6loFZR3/X8="
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

      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      extraOptions = ''
        !include ${config.sops.templates."nix-github-tokens".path}
      '';
    };
  };
}
