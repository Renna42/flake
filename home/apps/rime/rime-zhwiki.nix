{
  stdenvNoCC,
  sources,
}:
stdenvNoCC.mkDerivation {
  inherit (sources.rime-zhwiki) pname version src;

  dontUnpack = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data/dicts
    cp $src $out/share/rime-data/dicts/zhwiki.dict.yaml

    runHook postInstall
  '';
}
