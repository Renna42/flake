{unstablePkgs, ...}: {
  environment.systemPackages = with unstablePkgs; [
    bitwarden-desktop
  ];
}
