{...}: {
  programs.satty = {
    enable = true;
    settings = {
      Default = {
        auto_save = "$XDG_PICTURES_DIR/Screenshots";
      };
    };
  };
}
