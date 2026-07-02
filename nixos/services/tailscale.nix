{
  config,
  unstablePkgs,
  secretsPath,
  ...
}: {
  sops.secrets.tailscale_authkey = {
    format = "yaml";
    sopsFile = "${secretsPath}/tailscale-authkey.yaml";
  };

  services.tailscale = {
    enable = true;
    package = unstablePkgs.tailscale;
    disableUpstreamLogging = true;
    authKeyFile = config.sops.secrets.tailscale_authkey.path;
    extraSetFlags = [
      "--operator=renna"
      "--ssh"
    ];
  };
}
