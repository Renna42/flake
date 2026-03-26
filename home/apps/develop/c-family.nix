{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # keep-sorted start
      clang-analyzer
      cmake
      gcc
      gdb
      gnumake
      meson
      ninja
      # keep-sorted end
    ]
    ++ (lib.optionals pkgs.stdenv.isLinux [
      # Darwin platform have LLVM toolchain from Xcode
      clang-tools
      lldb
    ]);
}
