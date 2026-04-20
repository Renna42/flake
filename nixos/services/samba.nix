_: {
  services.samba = {
    enable = true;
    usershares.enable = true;
  };

  users.users.renna.extraGroups = ["samba"];
}
