{lib}: {
  makePackages = import ./make-packages.nix {inherit lib;};
}
