{pkgs, ...}: let
  pcsclitePkg =
    if pkgs.stdenv.isDarwin
    then pkgs.pcsclite
    else pkgs.pcscliteWithPolkit;
in {
  home.packages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    pcsc-tools
    pcsclitePkg
  ];
}
