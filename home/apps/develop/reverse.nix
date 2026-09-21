{
  lib,
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
    ../idapro
  ];

  home.packages = with unstablePkgs;
    [
      (binwalk.override {
        enableUnfree = true;
      })
    ]
    ++ (lib.optionals (!pkgs.stdenv.isDarwin) [
      detect-it-easy
    ]);
}
