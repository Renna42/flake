{pkgs, ...}: {
  home.packages = with pkgs; [
    go
    grpc-tools
  ];
}
