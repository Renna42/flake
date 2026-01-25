{
  stdenvNoCC,
  fetchzip,
  lib,
}:
stdenvNoCC.mkDerivation (
  finalAttrs: {
    pname = "MiSans L3";
    version = "0-unstable-2023-10-31";

    src = fetchzip {
      url = "https://hyperos.mi.com/font-download/MiSans_L3.zip";
      hash = "sha256-Hooruq+g2AyMRONuRh5QJnXTx5IxnkFlRYY/oPbKNug=";
      extension = "zip";
      stripRoot = false;
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      find . -name "*.otf" -exec install -Dm444 -t "$out/share/fonts/opentype" {} +
      find . -name "*.ttf" -exec install -Dm444 -t "$out/share/fonts/truetype" {} +

      runHook postInstall
    '';

    meta = {
      homepage = "https://hyperos.mi.com/font";
      license = lib.licenses.unfreeRedistributable;
      platforms = lib.platforms.all;
    };
  }
)
