{
  config,
  inputs,
  pkgs,
  ...
} @ osSpecialArgs: let
  username = "renna";
in {
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
        inputs.stylix.homeModules.stylix
        inputs.catppuccin.homeModules.catppuccin
        inputs.nix-index-database.homeModules.nix-index
        inputs.direnv-instant.homeModules.direnv-instant
        inputs.sops-nix.homeManagerModules.sops
      ];
      users."${username}".imports = [
        ../home/darwin-desktop.nix
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
      };
    };

    nix.settings.trusted-users = [username];

    system.primaryUser = username;
  };
}
