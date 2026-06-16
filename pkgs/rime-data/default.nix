{pkgs, ...}: let
  oh-my-rime = pkgs.callPackage ./oh-my-rime.nix {};
  rime-custom-pinyin-dictionary = pkgs.callPackage ./rime-custom-pinyin-dictionary.nix {};
  rime-moetype = pkgs.callPackage ./rime-moetype.nix {};
  rime-zhwiki = pkgs.callPackage ./rime-zhwiki.nix {};
  rime-renna-custom = pkgs.callPackage ./rime-renna-custom.nix {};
in
  pkgs.symlinkJoin {
    name = "rime-data";
    paths = with pkgs; [
      oh-my-rime
      nur.repos.jetcookies.rime-lmdg
      rime-custom-pinyin-dictionary
      rime-moetype
      rime-zhwiki
      rime-renna-custom
    ];
  }
