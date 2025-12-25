{username, ...}: {
  imports = [
    ./desktop.nix
  ];
  programs.home-manager.enable = true;
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      LANG = "zh_CN.UTF-8";
      LANGUAGE = "zh_CN:en_US";
    };
    stateVersion = "25.11";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
