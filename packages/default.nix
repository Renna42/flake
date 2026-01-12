{pkgs ? (import ../nixpkgs.nix) {}}: let
  misansFonts = pkgs.callPackage ./misans {};
in
  misansFonts
