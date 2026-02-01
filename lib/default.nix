{lib}: {
  makePackages = import ./make-packages.nix {inherit lib;};
  withOfflineInstaller = {
    flake,
    nixosConfig,
  }:
    import ./with-offline-installer.nix {
      inherit
        flake
        nixosConfig
        lib
        ;
    };
}
