{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gen-rdk";
  version = "0-unstable-2022-12-02";

  src = fetchurl {
    url = "https://www.legroom.net/files/software/gen-rdk.sh";
    hash = "sha256-a2/DG9ZdSCf0dpE9DQgMnqrRdi7YzFwA82iqq9QnhWk=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/

    cp $src $out/bin/gen-rdk
    chmod +x $out/bin/gen-rdk

    runHook postInstall
  '';

  meta = {
    platforms = lib.platforms.linux;
  };
})
