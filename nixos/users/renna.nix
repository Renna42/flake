{
  config,
  inputs,
  hostname,
  pkgs,
  ...
} @ osSpecialArgs: let
  username = "renna";
in {
  config = {
    users.users.${username} = {
      isNormalUser = true;
      description = "Renna";
      extraGroups = [
        "wheel"
        "video"
        "networkmanager"
        "docker"
        "podman"
        "input"
        "i2c"
        "plugdev"
        "dialout"
        "wireshark"
        "tss"
        "libvirtd"
      ];
      shell = pkgs.fish;
      initialHashedPassword = "$y$j9T$KHYs8lBhE5S.gupM7N/QE/$zurxi/XMT5n6aACZu9tz3RBLBQ6Ge/eCUwODOjRMqe0";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHL5pMTK8LGrizHB2VvgL1RG9cNKxAhYXb59NqSyAwpw"
      ];
    };

    programs.fish = {
      enable = true;
      useBabelfish = true;
    };

    home-manager = {
      sharedModules = [
        inputs.catppuccin.homeModules.catppuccin
        inputs.nix-index-database.homeModules.nix-index
        inputs.direnv-instant.homeModules.direnv-instant
        inputs.sops-nix.homeManagerModules.sops
      ];
      users."${username}".imports = [
        ../../home/${username}/configurations/${hostname}
      ];
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-bak";
      extraSpecialArgs = {
        inherit
          (osSpecialArgs)
          inputs
          outputs
          hostname
          secretsPath
          assetsPath
          ;
        inherit username;
        platform = config.nixpkgs.hostPlatform;
      };
    };

    nix.settings.trusted-users = [username];
  };
}
