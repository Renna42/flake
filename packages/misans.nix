{
  stdenvNoCC,
  fetchzip,
  lib,
}:
stdenvNoCC.mkDerivation (
  _finalAttrs: {
    pname = "MiSans";
    version = "0-unstable-2023-10-31";

    src = fetchzip {
      url = "https://hyperos.mi.com/font-download/MiSans.zip";
      hash = "sha256-MH4t7oXDUiH1TAm0xKa0AENmB1zoedd8X5BcQFNw8GM=";
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
