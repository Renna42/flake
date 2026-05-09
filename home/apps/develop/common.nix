{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      devenv
      just
      just-lsp
    ]
    ++ (lib.optionals pkgs.stdenv.isLinux [
      imhex
    ]);
}
