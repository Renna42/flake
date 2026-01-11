{
  inputs,
  outputs,
  ...
}: {
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
      ];
      warn-dirty = false;
      # Disable the built-in flake registry to speed up evaluation
      flake-registry = "";
    };
    gc.automatic = true;
    optimise.automatic = true;

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
