{pkgs, ...}: let
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
      };
      corePlugins = [
        {
          name = "sync";
          enable = false;
        }
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
    vaults.${vaultName}.enable = true;
  };

  stylix.targets.obsidian = {
    vaultNames = [vaultName];
    colors.enable = false;
  };
}
