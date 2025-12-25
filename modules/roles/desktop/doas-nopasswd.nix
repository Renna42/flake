{
  pkgs,
  users,
  ...
}: {
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        inherit users;
        keepEnv = true;
        noPass = true;
      }
    ];
  };
  environment.systemPackages = [pkgs.doas-sudo-shim];

  security.polkit.extraConfig = ''
    /* Allow members of the wheel group to execute any actions
    * without password authentication, similar to "sudo NOPASSWD:"
    */
    polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
  '';
}
