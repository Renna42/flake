{inputs, ...} @ osSpecialArgs: let
  username = "renna";
in {
  # "Yes, I think the status quo is that you shouldn’t use the users.users.* arguments on your main user, but frankly I forget why."
  # https://github.com/LnL7/nix-darwin/issues/811
  users.users."${username}" = {
    home = "/Users/${username}";
    description = "Renna Z.";
  };

  home-manager = {
    sharedModules = [
      inputs.nix-index-database.homeModules.nix-index
      inputs.sops-nix.homeManagerModules.sops
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
}
