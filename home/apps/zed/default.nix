{pkgs, ...}: let
  readJson = path: builtins.fromJSON (builtins.readFile path);
in {
  programs.zed-editor = {
    enable = true;
    extensions = [
      # keep-sorted start
      "astro"
      "biome"
      "docker-compose"
      "dockerfile"
      "git-firefly"
      "html"
      "just"
      "make"
      "nix"
      "toml"
      "wakatime"
      # keep-sorted end
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
