{
  config,
  secretsPath,
  ...
}: {
  sops.secrets.tailscale_authkey = {
    format = "yaml";
    sopsFile = "${secretsPath}/tailscale-authkey.yaml";
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale_authkey.path;
  };
}
