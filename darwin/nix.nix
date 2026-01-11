{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  nix = {
    # Use Lix
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      inherit (outputs.nix.settings) substituters;
      narinfo-cache-positive-ttl = 60 * 60 * 24;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

      fallback = true;

      # Disable the built-in flake registry to speed up evaluation
      flake-registry = "";
    };
    gc.automatic = true;
    optimise.automatic = true;

    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
