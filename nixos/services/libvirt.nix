{pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [virtiofsd];
      };
      extraConfig = ''
        unix_sock_group = "libvirtd"
      '';
    };
    spiceUSBRedirection.enable = true;
  };

  users.users.renna.extraGroups = ["libvirtd"];

  systemd.tmpfiles.rules = ["L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"];
}
