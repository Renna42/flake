{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "justonecacophony";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "TheM14";
    repo = "JustOneCacophony";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bUQ/mpSKcG+wnJqllW9+/stwYYp9HKLMIs9JieqBB9Y=";
  };

  nativeBuildInputs = [
    cmake
  ];

  hardeningDisable = [
    "libcxxhardeningfast"
  ];

  meta = {
    description = "An experimental/test implementation of E-AC-3 JOC";
    homepage = "https://github.com/TheM14/JustOneCacophony";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
