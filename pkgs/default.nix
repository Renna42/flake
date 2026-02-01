{
  lib,
  newScope,
}:
lib.makeScope newScope (
  self: let
    inherit (self) callPackage;
  in {
    # keep-sorted start block=yes
    dwproton-bin = callPackage ./dwproton-bin.nix {};
    misansFonts = lib.recurseIntoAttrs (callPackage ./misans-fonts {});
    openscreen = callPackage ./openscreen/package.nix {};
    rime-data = callPackage ./rime-data.nix {};
    zashboard = callPackage ./zashboard.nix {};
    # keep-sorted end
  }
)
