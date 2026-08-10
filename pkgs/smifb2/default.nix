{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "smifb";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "teddywlq";
    repo = "smifb2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hJS6hi9fVWBSEqkRAApg5OoDrd9n/1xxDs+GS+gFJUw=";
  };

  hardeningDisable = [
    "pic"
    "format"
  ]; # 1
  nativeBuildInputs = kernel.moduleBuildDependencies; # 2

  makeFlags =
    kernelModuleMakeFlags
    ++ [
      # "KERNELRELEASE=${kernel.modDirVersion}" # 3
      "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
      "DESTDIR=$(out)" # 5
    ];

  patches = [
    ../../patches/smifb2-fix-drm-helper.patch
    ../../patches/smifb2-fix-smi-pwm-remove.patch
    ../../patches/smifb2-fix-linux-6.17-build.patch
  ];

  meta = {
    description = "SiliconMotion SM768/SM750 PCIe driver";
    homepage = "https://github.com/teddywlq/smifb2";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
