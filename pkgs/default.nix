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
    linuxPackages_xanmod_latest = {
      smifb2 = pkgs.linuxPackages_xanmod_latest.callPackage ./smifb2 {};
    };
    obsidian-livesync = callPackage ./obsidian-livesync.nix {};
    obsidian-tasks = callPackage ./obsidian-tasks.nix {};
    rime-data = callPackage ./rime-data {};
    # keep-sorted end
  }
)
