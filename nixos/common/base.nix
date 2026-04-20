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

  security.openssl = {
    oqs-provider = {
      enable = true;
      package = pkgs.nur-xddxdd.openssl-oqs-provider;
      curves = [
        # Client: use generic curves first before OQS ones
        "x25519"
        "prime256v1"
        "x448"
        "secp521r1"
        "secp384r1"
        # OQS curves
        "X25519MLKEM768"
        "SecP256r1MLKEM768"
        "x25519_frodo640aes"
        "p256_frodo640aes"
        "x25519_bikel1"
        "p256_bikel1"
      ];
    };
    gost-engine = {
      enable = true;
      package = pkgs.nur-xddxdd.gost-engine;
    };
  };

  security.pki.certificateFiles = [
    "${pkgs.dn42-cacert}/etc/ssl/certs/dn42-ca.crt"
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
