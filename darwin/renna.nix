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
    users = {
      # "Yes, I think the status quo is that you shouldn’t use the users.users.* arguments on your main user, but frankly I forget why."
      # https://github.com/LnL7/nix-darwin/issues/811
      users."${username}" = {
        home = "/Users/${username}";
        description = "Renna Z.";
        uid = 501;
        shell = pkgs.fish;
      };
      knownUsers = [username];
    };

    home-manager = {
      sharedModules = [
        inputs.nix-index-database.homeModules.nix-index
        inputs.stylix.homeModules.stylix
      ];
      users."${username}".imports = [
        ../home/base.nix
      ];
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-bak";
      extraSpecialArgs = {
        inherit
          (osSpecialArgs)
          inputs
          system
          hostname
          unstablePkgs
          secretsPath
          assetsPath
          ;
        inherit username;
      };
    };

    nix.settings.trusted-users = [username];

    system.primaryUser = username;

    izmn.homeManager.modules = [
      ../home/darwin-desktop.nix
    ];
  };
}
