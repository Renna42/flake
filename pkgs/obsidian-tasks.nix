{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs_20,
  nix-update-script,
  nodejs ? nodejs_20,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "obsidian-tasks";
  version = "7.23.1";

  src = fetchFromGitHub {
    owner = "obsidian-tasks-group";
    repo = "obsidian-tasks";
    rev = "${finalAttrs.version}";
    hash = "sha256-ySNI7OsbUWYmOPPUR6iZyufN+kwbwanQWSVg6zA/PXI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
  ];

  offlineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-PXMN/05G1FIiR93seJSBilZDzXMv3o3cXDaEOUC71s0=";
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
