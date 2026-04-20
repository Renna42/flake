{pkgs, ...}: {
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
    usbmon.enable = true;
    dumpcap.enable = true;
  };

  users.users.renna.extraGroups = ["wireshark"];
}
