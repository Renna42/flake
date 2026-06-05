{
  lib,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      devenv
      just
      just-lsp
    ]
    ++ (lib.optionals pkgs.stdenv.isLinux [
      unstablePkgs.imhex
    ]);
}
