{
  stdenvNoCC,
  sources,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.rime-moetype) pname version src;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data/dicts
    cp $src $out/share/rime-data/dicts/tone_moe.dict.yaml

    runHook postInstall
  '';
})
