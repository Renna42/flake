{pkgs, ...}: {
  home.packages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubico-piv-tool
    pcsc-tools
    pcscliteWithPolkit
  ];
}
