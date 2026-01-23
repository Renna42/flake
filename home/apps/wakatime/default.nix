{
  config,
  lib,
  ...
}: {
  sops.secrets.wakatime_api_key = {};

  home.file.".wakatime.cfg" = {
    text = lib.generators.toINI {} {
      settings.api_key_vault_cmd = "cat ${config.sops.secrets.wakatime_api_key.path}";
    };
    force = true;
  };
}
