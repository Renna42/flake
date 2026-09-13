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
  version = "8.4.0";

  src = fetchFromGitHub {
    owner = "obsidian-tasks-group";
    repo = "obsidian-tasks";
    rev = "${finalAttrs.version}";
    hash = "sha256-8At6j4MuE08unH5ic90JqBl5y3R0/ply3M2nSUQwvBY=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs-slim
  ];

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-gdM+5S8u76HaGgXsaezXxibg4/p+OfXcuu3lZx9kvIk=";
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
