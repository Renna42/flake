{
  config,
  pkgs,
  unstablePkgs,
  ...
}: let
  vaultName = "Obsidian Vault";
in {
  programs.obsidian = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then unstablePkgs.obsidian
      else null;
    cli.enable = true;
    defaultSettings = {
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
          pkg = pkgs.renna.obsidian-livesync;
          enable = true;
        }
        {
          pkg = pkgs.renna.obsidian-tasks;
          enable = true;
        }
      ];
      themes = [
        {
          pkg = pkgs.renna.catppuccin-obsidian;
          enable = true;
        }
      ];
    };
    vaults.${vaultName} = {
      enable = true;
      target = "Documents/${vaultName}";
      settings.appearance = {
        "translucency" = true;
        "textFontFamily" = config.stylix.fonts.sansSerif.name;
      };
    };
  };

  stylix.targets.obsidian = {
    vaultNames = [vaultName];
    colors.enable = false;
  };
}
