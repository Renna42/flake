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
      discscape = callPackage ./discscape.nix {};
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
      orender = callPackage ./orender.nix {};
      rime-custom-pinyin-dictionary = callPackage ./rime-custom-pinyin-dictionary.nix {};
      rime-data = callPackage ./rime-data.nix {};
      rime-moetype = callPackage ./rime-moetype.nix {};
      rime-renna-custom = callPackage ./rime-renna-custom {};
      rime-zhwiki = callPackage ./rime-zhwiki.nix {};
      # keep-sorted end
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isx86 {
      exactaudiocopy = callPackage ./exactaudiocopy.nix {};
      ida-pro = let
        from = lib.concatStrings [
          "29f4481f796f9f66f2ff13cc4ab5b54f"
          "60845db603ba2c0bac8a9bc4b6cbdefc"
          "5c62bfc2f5ee850ac45ea97ad347e8b5"
          "6dba5085af8c8aad9cc2ec626ca78a06"
          "8006d658f68651da31a0a77c65a70ed7"
          "3a40d53b08edd403c095aa0bcffa52f3"
          "13ebcacaaa2ce5024a4e2b9aa70fc609"
          "2f38ae094d71e43f7690b5ddd3e9e4f7"
        ];
        to = lib.concatStrings [
          "a107b71c8a08ba5350934f7cf6e81be3"
          "a24dc2e35f7200d80cbd70b37ed6811d"
          "d2146d3cb7e20ad19b2544c0ef14c5c6"
          "6ffbbdf226ec3f3d544c04385303ca4a"
          "7179299340022f5d50948bcf8a60307e"
          "2c196329e51a5296dc419e40fef3ef7c"
          "6f015a09ebd979e79615338985643e66"
          "6c14897f9f597e11f44341f496d56861"
        ];
      in
        callPackage ./ida-pro.nix {
          hexPatches = [
            {
              inherit from to;
              filename = "libida.so";
              assertCount = 2;
            }
            {
              inherit from to;
              filename = "libida32.so";
              assertCount = 2;
            }
          ];
        };
    }
)
