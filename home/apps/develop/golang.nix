{pkgs, ...}: {
  home.packages = with pkgs; [
    go
    gopls
    grpc-tools
  ];
}
