{
  inputs,
  config,
  lib,
  hostname,
  ...
} @ osSpecialArgs: {
  options = {
    renna.server.homeManager.enable = lib.mkEnableOption "Enable home-manager for ${hostname}'s root user";
  };

  config = {
    users = {
      users.root = {
        initialHashedPassword = "$y$j9T$KHYs8lBhE5S.gupM7N/QE/$zurxi/XMT5n6aACZu9tz3RBLBQ6Ge/eCUwODOjRMqe0";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHL5pMTK8LGrizHB2VvgL1RG9cNKxAhYXb59NqSyAwpw"
        ];
      };
      mutableUsers = false;
    };

    home-manager = lib.mkIf config.renna.server.homeManager.enable {
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      users.root.imports = [
        ../../../home/server.nix
      ];
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-bak";
      extraSpecialArgs = {
        inherit
          (osSpecialArgs)
          inputs
          hostname
          overlays
          secretsPath
          assetsPath
          ;
        username = "root";
      };
    };
  };
}
