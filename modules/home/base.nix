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
      LANGUAGE = "zh_CN:zh:ja_JP:ja:en_US:en";
    };
    stateVersion = "25.11";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
