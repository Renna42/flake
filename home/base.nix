{
  lib,
  username,
  platform,
  ...
}: let
  homeDirectory =
    if platform.isDarwin
    then "/Users/${username}"
    else "/home/${username}";
in {
  programs.home-manager.enable = true;
  home = {
    inherit username homeDirectory;
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LANGUAGE = "en_US:en";
    };
    stateVersion = "25.11";
  };
  xdg.userDirs = lib.mkIf platform.isLinux {
    enable = true;
    createDirectories = true;
  };
}
