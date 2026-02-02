{pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
      extraConfig = ''
        unix_sock_group = "libvirtd"
      '';
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = [
    pkgs.virt-manager
  ];
}
