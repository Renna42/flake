{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # keep-sorted start
      automake
      clang-analyzer
      cmake
      gdb
      gnumake
      meson
      nasm
      ninja
      pkg-config
      # keep-sorted end
    ]
    ++ (lib.optionals pkgs.stdenv.isLinux [
      # Darwin platform have LLVM toolchain from Xcode
      clang-tools
      gcc
      lldb
    ]);
}
