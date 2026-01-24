{
  assetsPath,
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".idapro/idapro.hexlic".source = "${assetsPath}/idapro.hexlic";
    ".idapro/themes/catppuccin-${config.catppuccin.flavor}" = {
      source =
        pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "ida-debugger";
          rev = "22f43b265c03f4b77fe6bcd9b09dcc3705e3092d";
          hash = "sha256-aFTEgZ8eWlOOqoQsiQ5d/eqbkMGSjb5ImZPlFhlh/2g=";
        }
        + "/catppuccin-${config.catppuccin.flavor}";
      recursive = true;
    };
  };
}
