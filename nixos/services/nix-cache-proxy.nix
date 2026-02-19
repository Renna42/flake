{config, ...}: {
  services.nix-cache-proxy = {
    enable = true;
    listenAddress = "127.0.0.1:3429";
    upstreams =
      config.nix.settings.substituters
      ++ config.nix.settings.extra-substituters;
  };
}
