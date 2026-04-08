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
  version = "0.25.56";

  src = fetchFromGitHub {
    owner = "vrtmrz";
    repo = "obsidian-livesync";
    rev = "${finalAttrs.version}";
    hash = "sha256-2ygCC6Jhlw/IZi9ISArLLB6afQjkBoqzZwf0T01XX68=";

    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-4DEnf09kEiKIuqvQfNEeSvr1Cu1XEMvRTtQS9wiZ5o8=";
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
