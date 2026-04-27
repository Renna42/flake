{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zashboard-bin";
  version = "3.5.1";

  src = fetchzip {
    url = "https://github.com/Zephyruso/zashboard/releases/download/v${finalAttrs.version}/dist.zip";
    hash = "sha256-1EWwIh/7MdqNnXWwhWuHiM8lR2weAg8n2WMyFeQufRY=";
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
