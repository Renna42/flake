{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  # keep-sorted start
  alsa-lib,
  e2fsprogs,
  fontconfig,
  freetype,
  fribidi,
  gmp,
  kdePackages,
  libGL,
  libgbm,
  libgpg-error,
  libice,
  libsm,
  libx11,
  libxcb,
  zlib,
  # keep-sorted end
}: let
  selectSystem = attrs:
    attrs.${stdenv.hostPlatform.system}
            or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  version = selectSystem {
    x86_64-linux = "6.0.5.4007";
    aarch64-linux = "6.0.5.4008";
  };

  arch = selectSystem {
    x86_64-linux = "amd64";
    aarch64-linux = "arm64";
  };

  hash = selectSystem {
    x86_64-linux = "sha256-xAp1NzUrbIwoVVGzwTwov5IsdYlrvrzVSYVdyKijPxc=";
    aarch64-linux = "sha256-oxN5ybzqRqV0273NYDUAVuNutBkBpC+gpNf8kL8tv5A=";
  };

  libraries = [
    alsa-lib
    libgbm
    libgpg-error
    fribidi
    e2fsprogs
    gmp
    libGL
    libxcb
    libx11
    fontconfig
    freetype
    zlib
    libsm
    libice
    kdePackages.wayland
  ];
in
  stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "classin-bin";

    src = fetchurl {
      inherit hash;
      url = "https://www.eeo.cn/download/client/classin_${version}_${arch}.deb";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];

    buildInputs = libraries;

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack

      dpkg -X $src .

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/classin

      mv usr/share/* $out/share
      mv opt/apps/classin/* $out/share/classin

      substituteInPlace $out/share/applications/classin.desktop \
        --replace-fail "/opt/apps/classin/ClassIn" "$out/share/classin/ClassIn"

      runHook postInstall
    '';

    meta = {
      homepage = "https://www.eeo.cn";
      description = "One-Stop Solution to Hybrid Teaching and Learning";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [
        Renna42
      ];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  })
