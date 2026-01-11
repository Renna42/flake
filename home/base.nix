{
  lib,
  outputs,
  username,
  system,
  ...
}: let
  homeDirectory =
    if system == "aarch64-darwin"
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
  xdg.userDirs = lib.mkIf (system != "aarch64-darwin") {
    enable = true;
    createDirectories = true;
  };
}
