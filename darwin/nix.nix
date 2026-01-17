{
  config,
  inputs,
  outputs,
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
    settings = {
      inherit (outputs.nix.settings) substituters;
      narinfo-cache-positive-ttl = 60 * 60 * 24;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
      warn-dirty = false;
      # Disable the built-in flake registry to speed up evaluation
      flake-registry = "";
    };
    gc.automatic = true;
    optimise.automatic = true;

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  environment.variables.SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
}
