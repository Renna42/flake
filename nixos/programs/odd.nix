{pkgs, ...}: {
  boot.kernelModules = ["sg"]; # MakeMKV needed

  users.users.renna.extraGroups = ["cdrom"];
  services.udev.extraRules = ''
    # Optical Drive access for K3b
    KERNEL=="sr[0-9]*", GROUP="cdrom", MODE="0660"
  '';

  environment.systemPackages = with pkgs; [
    # keep-sorted start case=no
    cdrdao
    cdrtools
    dvdplusrwtools
    flakePackages.gen-rdk
    libbluray-full
    udftools
    whipper
    # keep-sorted end
  ];
}
