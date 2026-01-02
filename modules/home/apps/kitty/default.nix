_: {
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    shellIntegration = {
      enableFishIntegration = true;
    };

    font.size = 12;
    mouseBindings = {
      "left click" = "ungrabbed no-op";
      "ctrl+left click" = "grabbed,ungrabbed mouse_click_url";
    };
  };
}
