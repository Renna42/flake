{
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    shellIntegration = {
      enableFishIntegration = true;
    };

    mouseBindings = {
      "left click" = "ungrabbed no-op";
      "ctrl+left click" = "grabbed,ungrabbed mouse_click_url";
    };

    settings = {
      "shell" = lib.getExe pkgs.fish;
      "window_padding_width" = 10;
    };
  };
}
