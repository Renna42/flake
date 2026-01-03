{lib, ...}: {
  # Ensure greetd is not enabled anywhere by default (hosts can override if needed)
  services.greetd.enable = lib.mkDefault false;

  services.displayManager.ly = {
    enable = true;
    settings = {
      bigclock = true;
      clock = "%c";
      bg = "0x00080808";
    };
  };
}
