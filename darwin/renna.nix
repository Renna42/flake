{pkgs, ...}: let
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

    nix.settings.trusted-users = [username];

    system.primaryUser = username;
  };
}
