{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs-slim_20,
  nix-update-script,
  nodejs-slim ? nodejs-slim_20,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "obsidian-tasks";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "obsidian-tasks-group";
    repo = "obsidian-tasks";
    rev = "${finalAttrs.version}";
    hash = "sha256-7zroMWL9YY9XpLJNzMR450h6ZURlUfbxJOojzflMbUI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs-slim
  ];

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-n2ohtNPncC3tDYC7VL2zKr/UXQp6CCAdKTotJtV00mg=";
  };

  buildPhase = ''
    runHook preBuild

    yarn run build

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
    description = "Task management for the Obsidian knowledge base";
    homepage = "https://github.com/obsidian-tasks-group/obsidian-tasks";
    changelog = "https://github.com/obsidian-tasks-group/obsidian-tasks/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Renna42
    ];
    platforms = lib.platforms.all;
  };
})
