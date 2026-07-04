{
  pkgs,
  unstablePkgs,
  ...
}: let
  cmd =
    if pkgs.stdenv.isDarwin
    then "cmd"
    else "ctrl";
in {
  programs.kitty = {
    enable = true;
    package =
      if !pkgs.stdenv.isDarwin
      then unstablePkgs.kitty
      else null;
    enableGitIntegration = true;
    shellIntegration = {
      enableFishIntegration = true;
    };

    keybindings = {
      "${cmd}+[" = "previous_window";
      "${cmd}+]" = "next_window";
      "${cmd}+shift+n" = "new_os_window_with_cwd";
      "${cmd}+shift+w" = "close_window";
      "${cmd}+shift+]" = "next_window";
      "${cmd}+shift+[" = "previous_window";
      "${cmd}+shift+d" = "launch --location=vsplit";
      "${cmd}+shift+r" = "launch --location=hsplit";
    };
    mouseBindings = {
      "left click" = "ungrabbed no-op";
      "${cmd}+left click" = "grabbed,ungrabbed mouse_click_url";
    };

    settings = {
      # keep-sorted start
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enabled_layouts = "splits";
      input_delay = 0;
      repaint_delay = 6; # Handle 165 Hz display
      resize_in_steps = true;
      strip_trailing_spaces = "smart";
      sync_to_monitor = true;
      window_padding_width = 10;
      # keep-sorted end
    };
  };
}
