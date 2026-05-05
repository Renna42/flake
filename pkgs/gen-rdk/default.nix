{
  lib,
  stdenvNoCC,
  makemkv,
  hexdump,
  udisks,
  openssl_3,
  openssl ? openssl_3,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gen-rdk";
  version = "0-unstable-2022-11-26";

  src = ./gen-rdk.sh;

  buildInputs = [
    makemkv
    hexdump
    udisks
    openssl
  ];

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
