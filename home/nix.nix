{
  osConfig,
  inputs,
  lib,
  ...
}: {
  nix = {
    inherit (osConfig.nix) settings;
    # This is important. It locks nixpkgs registry used in nix shell
    # to the same of flakes. Saves time.
    registry =
      {
        pkgs.flake = inputs.self;
      }
      // lib.mapAttrs (_: flakes: {flake = flakes;}) inputs;
  };
}
