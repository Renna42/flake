{
  sources,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit (sources.rime-custom-pinyin-dictionary) pname version src;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data/dicts
    cp $src $out/share/rime-data/dicts/CustomPinyinDictionary.dict.yaml

    runHook postInstall
  '';
}
