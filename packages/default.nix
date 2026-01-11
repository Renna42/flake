{pkgs ? (import ../nixpkgs.nix) {}}: (
  pkgs.callPackage ./misans {}
)
