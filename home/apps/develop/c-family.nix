{pkgs, ...}: {
  home.packages = with pkgs; [
    # keep-sorted start
    clang-analyzer
    clang-tools
    cmake
    gcc
    gdb
    gnumake
    lldb
    meson
    ninja
    # keep-sorted end
  ];
}
