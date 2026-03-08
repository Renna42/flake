{pkgs, ...}: {
  boot.kernelModules = ["sg"]; # MakeMKV needed

  users.users.renna.extraGroups = ["cdrom"];
  services.udev.extraRules = ''
    # Optical Drive access for K3b
    KERNEL=="sr[0-9]*", GROUP="cdrom", MODE="0660"
  '';

  environment.systemPackages = with pkgs; [
    dvdplusrwtools
    udftools
  ];
}
