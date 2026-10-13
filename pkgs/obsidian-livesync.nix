{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs-slim_24,
  nix-update-script,
  nodejs ? nodejs-slim_24,
}:
buildNpmPackage (finalAttrs: {
  inherit nodejs;

  pname = "obsidian-livesync";
  version = "1.0.35";

  src = fetchFromGitHub {
    owner = "vrtmrz";
    repo = "obsidian-livesync";
    rev = "${finalAttrs.version}";
    hash = "sha256-D5PEcPC5DGAW4xsHCFjlAmYaoUs8H+0eZBnSGkhWULU=";

    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-rwkk0XWGeMCuBhlj9VpFyF5Y1A4Fb9NNUpY9ADqmZrI=";
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
