_: {
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
      "shell" = "fish";
      "window_padding_width" = 10;
    };
  };
}
