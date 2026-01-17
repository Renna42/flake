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
      # make kitty dont alias sudo to make doas works well
      # ref: https://github.com/NixOS/nixpkgs/issues/260427#issuecomment-1758197272
      mode = "no-sudo";
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
