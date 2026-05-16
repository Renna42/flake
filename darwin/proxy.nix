{
  config,
  lib,
  pkgs,
  secretsPath,
  ...
}: let
  mihomoWebui = pkgs.zashboard;
in {
  sops.secrets.mihomoConfig = {
    format = "yaml";
    sopsFile = "${secretsPath}/mihomo-config.yaml";
    key = "";
    mode = "0400";
    owner = "root";
  };

  launchd.daemons.mihomo = {
    serviceConfig = {
      Label = "mihomo";
      RunAtLoad = true;
      KeepAlive = true;
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path /nix/store && exec ${lib.getExe pkgs.mihomo} -d \"/Library/Application Support/mihomo\" -f ${config.sops.secrets.mihomoConfig.path} -ext-ui ${mihomoWebui}"
      ];
      WorkingDirectory = "/Library/Application Support/mihomo/";
      StandardOutPath = "/Library/Application Support/mihomo/log.out";
      StandardErrorPath = "/Library/Application Support/mihomo/log.err";
    };
  };
}
