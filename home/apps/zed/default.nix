{pkgs, ...}: let
  readJson = path: builtins.fromJSON (builtins.readFile path);
in {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "astro"
      "biome"
      "dockerfile"
      "docker-compose"
      "git-firefly"
      "html"
      "just"
      "make"
      "nix"
      "toml"
      "wakatime"
    ];
    extraPackages = [
      pkgs.nixd
    ];
    userSettings = readJson ./settings.json;
  };

  stylix.targets.zed.colors.enable = false;
  catppuccin.zed = {
    enable = true;
    icons.enable = true;
  };
}
