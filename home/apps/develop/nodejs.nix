{pkgs, ...}: {
  home.packages = with pkgs; [
    nodejs_24
    pnpm
    yarn
  ];
}
