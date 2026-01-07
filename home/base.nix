{username, ...}: {
  imports = [
    ./desktop.nix
  ];
  programs.home-manager.enable = true;
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LANGUAGE = "en_US:en";
    };
    stateVersion = "25.11";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
