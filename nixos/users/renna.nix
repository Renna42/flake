{
  lib,
  pkgs,
  ...
}: let
  username = "renna";
in {
  users.users.${username} = {
    isNormalUser = true;
    description = "Renna";
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
      "docker"
      "podman"
      "input"
      "i2c"
      "plugdev"
      "dialout"
      "wireshark"
      "tss"
    ];
    shell = pkgs.fish;
    initialHashedPassword = "$y$j9T$KHYs8lBhE5S.gupM7N/QE/$zurxi/XMT5n6aACZu9tz3RBLBQ6Ge/eCUwODOjRMqe0";
  };
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };
  nix.settings.trusted-users = [username];
}
