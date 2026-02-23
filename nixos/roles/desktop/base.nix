{
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ../../gui/stylix.nix
  ];

  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
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

  services.resolved.enable = true;
  services.udisks2.enable = true;

  # Set hardware time to local
  time.hardwareClockInLocalTime = true;

  environment.systemPackages = with pkgs; [
    xdg-user-dirs
  ];

  sops.age.keyFile = "/home/renna/.config/sops/age/keys.txt";
}
