{
  lib,
  pkgs,
  ...
}: {
  services.scx = {
    enable = true;
    package = lib.mkDefault pkgs.scx.rustscheds;
    scheduler = lib.mkDefault "scx_lavd";
    extraArgs = lib.mkDefault [
      "--performance"
    ];
  };
}
