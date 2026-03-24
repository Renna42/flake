{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zashboard-bin";
  version = "2.8.0";

  src = fetchzip {
    url = "https://github.com/Zephyruso/zashboard/releases/download/v${finalAttrs.version}/dist.zip";
    hash = "sha256-uI1BZEADLiTO/efl8OPM1s+dLotZTawdVPO5QcfzzOU=";
  };

  dontConfigure = true;
  dontBuild = true;
  doInstallCheck = true;

  installPhase = ''
    runHook preInstall

    cp -r $src $out

    runHook postInstall
  '';

  meta = {
    description = "Dashboard Using Clash API";
    homepage = "https://github.com/Zephyruso/zashboard";
    changelog = "https://github.com/Zephyruso/zashboard/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
