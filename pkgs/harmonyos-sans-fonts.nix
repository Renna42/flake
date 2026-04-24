{
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  pname = "harmonyos-sans-fonts";
  version = "0-unstable-2022-07-04";

  src = fetchzip {
    url = "https://developer.huawei.com/images/download/general/HarmonyOS-Sans.zip";
    hash = "sha256-c10AIlce3WSqzKI9cq9LoobRJHgbqnzBo/d958Acz/A=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    find . -name "*.ttf" -exec install -Dm444 -t "$out/share/fonts/truetype" {} +

    runHook postInstall
  '';
}
