{pkgs, ...}: {
  imports = [
    ../../desktop/stylix.nix
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
    nameservers = [
      "119.29.29.29" # Tencent
      "223.5.5.5" # AliDNS
      "8.8.4.4" # Google
      "1.1.1.1" # Cloudflare
      "9.9.9.9" # Quad9
    ];
  };

  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-user-dirs
  ];
}
