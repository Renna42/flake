{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libfvad";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "dpirch";
    repo = "libfvad";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DiqLlPefbQc+Q56ktDDHjEpk6gGyl9Rr5QKR5mPe1zo=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  meta = {
    description = "Voice activity detection (VAD) library, based on WebRTC's VAD engine";
    homepage = "https://github.com/dpirch/libfvad";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
