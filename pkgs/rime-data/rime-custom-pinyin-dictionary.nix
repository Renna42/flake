{
  sources,
  stdenvNoCC,
  imewlconverter,
}:
stdenvNoCC.mkDerivation {
  inherit (sources.rime-custom-pinyin-dictionary) pname version src;

  sourceRoot = ".";

  nativeBuildInputs = [
    imewlconverter
  ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    ImeWlConverterCmd -i:libpy $src -o:rime CustomPinyinDictionary.dict.yaml

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data/dicts
    cp CustomPinyinDictionary.dict.yaml $out/share/rime-data/dicts/CustomPinyinDictionary.dict.yaml

    runHook postInstall
  '';
}
