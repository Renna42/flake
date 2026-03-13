{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    arion
    docker-client
    podman-compose
  ];

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      package = pkgs.podman;
      dockerSocket.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
