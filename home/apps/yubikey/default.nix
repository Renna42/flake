{
  pkgs,
  platform,
  ...
}: let
  pcsclitePkg =
    if platform.isDarwin
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
