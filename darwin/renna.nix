{
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
          unstablePkgs
          secretsPath
          assetsPath
          ;
        inherit username;
      };
    };

    nix.settings = {
      allowed-users = [username];
      trusted-users = [username];
    };

    system.primaryUser = username;
  };
}
