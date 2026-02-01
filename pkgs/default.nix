{
  lib,
  newScope,
}:
lib.makeScope newScope (
  self: let
    inherit (self) callPackage;
  in {
    # keep-sorted start block=yes
    misansFonts = lib.recurseIntoAttrs (callPackage ./misans-fonts {});
    openscreen = callPackage ./openscreen {};
    rime-data = callPackage ./rime-data.nix {};
    zashboard = callPackage ./zashboard.nix {};
    # keep-sorted end
  }
)
