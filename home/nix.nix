{
  config,
  osConfig,
  inputs,
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
    inherit (osConfig.nix) settings;
    # This is important. It locks nixpkgs registry used in nix shell
    # to the same of flakes. Saves time.
    registry =
      {
        pkgs.flake = inputs.self;
      }
      // lib.mapAttrs (_: flakes: {flake = flakes;}) inputs;

    extraOptions = ''
      !include ${config.sops.templates."nix-github-tokens".path}
    '';
  };
}
