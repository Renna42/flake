{
  inputs,
  lib,
  pkgs,
  ...
} @ osSpecialArgs: let
  username = "renna";
in {
  options = {
    izmn.homeManager = {
      modules = lib.mkOption {
        default = [];
        description = "Extra modules for home-manager";
      };
    };
  };
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
      ];
      shell = pkgs.fish;
      initialHashedPassword = "$y$j9T$KHYs8lBhE5S.gupM7N/QE/$zurxi/XMT5n6aACZu9tz3RBLBQ6Ge/eCUwODOjRMqe0";
    };
    programs.fish = {
      enable = true;
      useBabelfish = true;
    };
    home-manager = {
      sharedModules = [
        inputs.nix-index-database.homeModules.nix-index
      ];
      useGlobalPkgs = true;
      useUserPackages = true;
      overwriteBackup = true;
      backupFileExtension = "hm-bak";
      extraSpecialArgs = {
        inherit
          (osSpecialArgs)
          inputs
          system
          hostname
          assetsPath
          ;
        inherit username;
      };
      users.${username}.imports = [
        ../../home/base.nix
      ];
    };
    nix.settings.trusted-users = [username];
  };
}
