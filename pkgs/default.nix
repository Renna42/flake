{
  lib,
  pkgs,
  newScope,
}:
lib.makeScope newScope (
  self: let
    inherit (self) callPackage;
  in {
    # keep-sorted start block=yes
    dwproton-bin = callPackage ./dwproton-bin.nix {};
    linuxPackages_xanmod_latest = {
      smifb2 = pkgs.linuxPackages_xanmod_latest.callPackage ./smifb2 {};
    };
    misansFonts = lib.recurseIntoAttrs (callPackage ./misans-fonts {});
    rime-data = callPackage ./rime-data.nix {};
    zashboard-bin = callPackage ./zashboard-bin.nix {};
    # keep-sorted end
  }
)
