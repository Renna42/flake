{pkgs, ...}: {
  services.gnome.evolution-data-server = {
    enable = true;
    plugins = with pkgs; [
      evolution
      evolution-ews
    ];
  };
  programs.dconf.enable = true;
}
