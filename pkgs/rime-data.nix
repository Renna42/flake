{
  lib,
  pkgs,
  ...
}:
with pkgs.nur.repos.linyinfeng.rimePackages;
  pkgs.symlinkJoin {
    name = "rime-data";
    paths =
      (withRimeDeps [rime-ice])
      ++ (with pkgs.nur.repos; [
        pkgs.rime-data
        linyinfeng.rimePackages.rime-emoji
        xddxdd.rime-moegirl
        xddxdd.rime-zhwiki
      ]);
    meta = {
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  }
