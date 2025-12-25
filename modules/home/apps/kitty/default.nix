{lib, ...}: {
  programs.kitty = {
    enable = true;
    settings = {
      font.size = 12.0;
      shell_integration = "enabled";
    };
  };
}
