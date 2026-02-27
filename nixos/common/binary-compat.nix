{lib, ...}: {
  options = {
    renna.enableBinaryCompat =
      lib.mkEnableOption "Enable binary compatibility with FHS programs"
      // {
        default = true;
      };
  };

  config = {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    programs.nix-ld.enable = true;
  };
}
