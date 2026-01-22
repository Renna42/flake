{
  config,
  pkgs,
  ...
}: let
  format = pkgs.formats.ini {};
in {
  sops.secrets.wakatime_api_key = {};

  home.file.".wakatime.cfg" = {
    source = format.generate ".wakatime.cfg" {
      settings.api_key_vault_cmd = "cat ${config.sops.secrets.wakatime_api_key.path}";
    };
    force = true;
  };
}
