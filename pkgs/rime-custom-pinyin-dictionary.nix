{
  sources,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.rime-custom-pinyin-dictionary) pname version src;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data/dicts
    cat - $src > $out/share/rime-data/dicts/CustomPinyinDictionary.dict.yaml <<EOF
    ---
    name: CustomPinyinDictionary
    version: "${finalAttrs.version}"
    sort: by_weight
    ...

    EOF

    runHook postInstall
  '';
})
