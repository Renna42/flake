{osConfig, ...}: {
  nix = {inherit (osConfig.nix) settings;};
}
