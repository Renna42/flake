{pkgs, ...}: let
  readJson = path: builtins.fromJSON (builtins.readFile path);
in {
  programs.zed-editor = {
    enable = true;
    package =
      if !pkgs.stdenv.isDarwin
      then pkgs.zed-editor
      else null;
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
    userSettings = readJson ./settings.json;
  };

  stylix.targets.zed.colors.enable = false;
  catppuccin.zed = {
    enable = true;
    icons.enable = true;
  };
}
