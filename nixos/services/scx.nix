{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    renna.enableScxConfig =
      lib.mkEnableOption "Enable SCX configurations in the flake."
      // {
        default = true;
      };
  };

  config = {
    services.scx =
      {
        enable = true;
      }
      // (lib.mkIf config.renna.enableScxConfig {
        package = pkgs.scx.rustscheds;
        scheduler = "scx_lavd";
        extraArgs = [
          "--performance"
        ];
      });
  };
}
