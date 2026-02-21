{
  lib,
  config,
  inputs,
  pkgs,
  ...
} @ osSpecialArgs: let
  username = "renna";
in {
  options = {
    renna.homeManager = {
      enable = lib.mkEnableOption "Enable home-manager for Renna Z.";
    };
  };

  config = {
    users.users.${username} = {
      isNormalUser = true;
      description = "Renna";
      extraGroups = [
        # keep-sorted start block=yes
        "dialout"
        "docker"
        "i2c"
        "input"
        "libvirtd"
        "networkmanager"
        "podman"
        "render"
        "tss"
        "video"
        "wheel"
        "wireshark"
        # keep-sorted end
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

    home-manager = lib.mkIf config.renna.homeManager.enable {
      sharedModules = [
        inputs.catppuccin.homeModules.catppuccin
        inputs.nix-index-database.homeModules.nix-index
        inputs.direnv-instant.homeModules.direnv-instant
        inputs.sops-nix.homeManagerModules.sops
      ];
      users."${username}".imports = [
        ../../home/linux-desktop.nix
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
        inherit username;
        platform = config.nixpkgs.hostPlatform;
      };
    };

    nix.settings.trusted-users = [username];
  };
}
