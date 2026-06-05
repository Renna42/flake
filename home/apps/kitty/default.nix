{
  lib,
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
      # "${cmd}+d" = "launch --location=hsplit";
      # "${cmd}+r" = "launch --location=vsplit";
      # "${cmd}+w" = "close_window";
      "${cmd}+[" = "previous_window";
      "${cmd}+]" = "next_window";
    };

    mouseBindings = {
      "left click" = "ungrabbed no-op";
      "${cmd}+left click" = "grabbed,ungrabbed mouse_click_url";
    };

    settings = {
      "shell" = lib.getExe pkgs.fish;
      "window_padding_width" = 10;
      "dynamic_background_opacity" = true;
      "strip_trailing_spaces" = "smart";
      "enabled_layouts" = "grid";
    };
  };
}
