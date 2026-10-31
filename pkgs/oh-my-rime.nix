{
  sources,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  inherit (sources.oh-my-rime) pname version src;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    cp -r * $out/share/rime-data/

    runHook postInstall
  '';
}
