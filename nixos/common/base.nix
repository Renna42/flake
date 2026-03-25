{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    binutils
    curl
    dnsutils
    file
    git
    gptfdisk
    htop
    inetutils
    iw
    killall
    lshw
    net-tools
    pciutils
    pv
    tldr
    usbutils
    vim
    wget
    # keep-sorted end
  ];

  security.pki.certificateFiles = [
    "${pkgs.dn42-cacert}/etc/ssl/certs/dn42-ca.crt"
  ];

  boot.supportedFilesystems = [
    "btrfs"
    "ext4"
    "exfat"
    "fat32"
    "xfs"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
