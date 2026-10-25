{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ffmpeg,
  fftw,
  libfvad,
  zlib,
  onnxruntime,
  python3Packages,
  makeWrapper,
  ctestCheckHook,
  withSilero ? false,
}: let
  onnxLib =
    if stdenv.hostPlatform.isDarwin
    then "${onnxruntime.out}/lib/libonnxruntime.dylib"
    else "${onnxruntime.out}/lib/libonnxruntime.so";
  sileroModel = "${python3Packages.silero-vad.src}/data/silero_vad.onnx";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "lapse" + lib.optionalString withSilero "-silero";
    version = "2.3.0";

    src = fetchFromGitHub {
      owner = "Schwponaco-org";
      repo = "lapse";
      rev = "v${finalAttrs.version}";
      hash = "sha256-cHCRVZLH5eB5SrKRGA4COUdyOYuo4NSkK7XRwgoJw6k=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
      ffmpeg.dev
      fftw.dev
      libfvad
      zlib.dev
      makeWrapper
    ];

    doCheck = true;

    postPatch = ''
      substituteInPlace engine/decoder.h \
        --replace '#include <fvad.h>' $'extern "C" {\n#include <fvad.h>\n}'
    '';

    postInstall = lib.optionalString withSilero ''
      wrapProgram $out/bin/lapse \
        --prefix LAPSE_ONNXRUNTIME : ${onnxLib} \
        --prefix LAPSE_VAD_MODEL : ${sileroModel}
    '';

    nativeCheckInputs = [
      ctestCheckHook
    ];

    meta = {
      description = "Language-Agnostic Playback Synchronization Engine";
      homepage = "https://github.com/Schwponaco-org/lapse";
      license = lib.licenses.gpl3Plus;
      mainProgram = "lapse";
      platforms = lib.platforms.unix;
    };
  })
