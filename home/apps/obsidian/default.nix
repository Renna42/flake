{
  config,
  pkgs,
  ...
}: let
  vaultName = "Obsidian Vault";
in {
  programs.obsidian = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.obsidian
      else null;
    cli.enable = true;
    defaultSettings = {
      appearance = {
        "translucency" = true;
        "textFontFamily" = config.stylix.fonts.sansSerif.name;
      };
      corePlugins = [
        # keep-sorted start
        "backlink"
        "bases"
        "bookmarks"
        "canvas"
        "command-palette"
        "daily-notes"
        "editor-status"
        "file-explorer"
        "file-recovery"
        "footnotes"
        "global-search"
        "graph"
        "note-composer"
        "outgoing-link"
        "outline"
        "page-preview"
        "properties"
        "slash-command"
        "slides"
        "switcher"
        "tag-pane"
        "word-count"
        # keep-sorted end
      ];
      communityPlugins = [
        {
          pkg = pkgs.flakePackages.obsidian-livesync;
          enable = true;
        }
      ];
      themes = [
        {
          pkg = pkgs.nur.repos.Ev357.catppuccin-obsidian;
          enable = true;
        }
      ];
    };
    vaults.${vaultName} = {
      enable = true;
      target = "Documents/${vaultName}";
    };
  };

  stylix.targets.obsidian = {
    vaultNames = [vaultName];
    colors.enable = false;
  };
}
