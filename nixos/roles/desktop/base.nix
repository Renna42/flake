{pkgs, ...}: {
  imports = [
    ../../gui/stylix.nix
  ];

  networking = {
    networkmanager.enable = true;
    # proxy = {
    #   default = "http://10.22.0.114:7890";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };
    firewall = {
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
      enable = false;
    };
  };

  services.udisks2.enable = true;

  # Building man-cache is too slow, use this trick to inhibit it.
  # Only do that on my desktop machines because we have `fish`.
  # Source: https://discourse.nixos.org/t/slow-build-at-building-man-cache/52365
  documentation.man.generateCaches = false;

  # Set hardware time to local
  time.hardwareClockInLocalTime = true;

  environment.systemPackages = with pkgs; [
    xdg-user-dirs
  ];

  sops.age.keyFile = ["/home/renna/.config/sops/age/keys.txt"];
}
