{
  lib,
  fetchFromGitHub,
  rustPlatform,
  ffmpeg,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ilass";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "SandroHc";
    repo = "ilass";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MoICwbSAqWiEAPyy9iVWobV1a7hLci3IsrKHq2xFwAY=";
  };

  cargoHash = "sha256-tByC4gUDSMfpqSaZi73aWM0zdh5RgnvIHV9Flp96SCI=";

  buildInputs = [
    ffmpeg
  ];

  meta = {
    description = "Intelligent Language-Agnostic Subtitle Synchronization";
    homepage = "https://github.com/SandroHc/ilass";
    license = lib.licenses.agpl3Plus;
    mainProgram = "ilass";
    platforms = lib.platforms.unix;
  };
})
