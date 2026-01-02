{
  pkgs,
  lib,
  ...
}: {
  niri-flake.cache.enable = false;

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
}
