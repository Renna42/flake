{
  lib,
  pkgs,
  username,
  secretsPath,
  ...
}: let
  homeDirectory =
    if pkgs.stdenv.isDarwin
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

  sops = {
    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = "${secretsPath}/home.yaml";
  };

  xdg.userDirs = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    createDirectories = true;
  };
}
