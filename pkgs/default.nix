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
    aegisub-arch1t3cht = callPackage ./aegisub-arch1t3cht.nix {};
    catppuccin-obsidian = callPackage ./catppuccin-obsidian.nix {};
    gen-rdk = callPackage ./gen-rdk {};
    harmonyos-sans-fonts = callPackage ./harmonyos-sans-fonts.nix {};
    linuxPackages_xanmod_latest = {
      smifb2 = pkgs.linuxPackages_xanmod_latest.callPackage ./smifb2 {};
    };
    misansFonts = lib.recurseIntoAttrs (callPackage ./misans-fonts {});
    obsidian-livesync = callPackage ./obsidian-livesync.nix {};
    obsidian-tasks = callPackage ./obsidian-tasks.nix {};
    # keep-sorted end
  }
)
