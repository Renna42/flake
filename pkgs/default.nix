{
  lib,
  pkgs,
  newScope,
}:
lib.makeScope newScope (
  self: let
    inherit (self) callPackage;
  in
    {
      # keep-sorted start block=yes
      aegisub-arch1t3cht = callPackage ./aegisub-arch1t3cht.nix {};
      catppuccin-obsidian = callPackage ./catppuccin-obsidian.nix {};
      ffmpeg-renna = callPackage ./ffmpeg-renna.nix {
        ffmpegVariant = "small";
      };
      ffmpeg-renna-full = callPackage ./ffmpeg-renna.nix {
        ffmpegVariant = "full";
      };
      ffmpeg-renna-headless = callPackage ./ffmpeg-renna.nix {
        ffmpegVariant = "headless";
      };
      fsdecrypt = callPackage ./fsdecrypt.nix {};
      gen-rdk = callPackage ./gen-rdk {};
      harletty-bridge = callPackage ./harletty-bridge.nix {};
      ilass = callPackage ./ilass.nix {};
      justonecacophony = callPackage ./justonecacophony.nix {};
      lapse = callPackage ./lapse.nix {};
      lapse-silero = callPackage ./lapse.nix {
        withSilero = true;
      };
      libfvad = callPackage ./libfvad.nix {};
      linuxPackages_xanmod_latest = {
        smifb2 = pkgs.linuxPackages_xanmod_latest.callPackage ./smifb2 {};
      };
      obsidian-livesync = callPackage ./obsidian-livesync.nix {};
      obsidian-tasks = callPackage ./obsidian-tasks.nix {};
      oh-my-rime = callPackage ./oh-my-rime.nix {};
      rime-custom-pinyin-dictionary = callPackage ./rime-custom-pinyin-dictionary.nix {};
      rime-moetype = callPackage ./rime-moetype.nix {};
      rime-renna-custom = callPackage ./rime-renna-custom {};
      rime-zhwiki = callPackage ./rime-zhwiki.nix {};
      # keep-sorted end
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isx86 {
      exactaudiocopy = callPackage ./exactaudiocopy.nix {};
    }
)
