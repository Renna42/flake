{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  nix-update-script,
  nodejs ? nodejs_24,
}:
buildNpmPackage (finalAttrs: {
  inherit nodejs;

  pname = "obsidian-livesync";
  version = "0.25.63";

  src = fetchFromGitHub {
    owner = "vrtmrz";
    repo = "obsidian-livesync";
    rev = "${finalAttrs.version}";
    hash = "sha256-CLk7p6Ury3rnUIM5d6z/UbcCTppyhSS6jAxrDcNcVgU=";

    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-g6cggnJZHVhiSn+FkdoQ7w374d4HmoJgWpu8KR69TFo=";
  npmFlags = ["--ignore-scripts"];

  buildPhase = ''
    runHook preBuild

    npm run build --if-present

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp main.js manifest.json styles.css $out/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Community implementation of self-hosted livesync for Obsidian";
    homepage = "https://github.com/vrtmrz/obsidian-livesync";
    changelog = "https://github.com/vrtmrz/obsidian-livesync/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Renna42
    ];
    platforms = lib.platforms.all;
  };
})
