{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "justonecacophony";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "TheM14";
    repo = "JustOneCacophony";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XxiUH9NnC24RZRQ6TwNRlcgbTFsQWoc6TQWO5gdw0H8=";
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
