{pkgs, ...}: let
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHL5pMTK8LGrizHB2VvgL1RG9cNKxAhYXb59NqSyAwpw"
    ];
  };
  programs.fish = {
    enable = true;
    useBabelfish = true;
  };
  nix.settings.trusted-users = [username];
}
