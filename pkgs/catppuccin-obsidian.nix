{
  stdenv,
  lib,
  fetchFromGitHub,
  nodejs-slim,
  pnpmConfigHook,
  fetchPnpmDeps,
  pnpm,
  ...
}: let
  version = "2.0.4";
  commitHash = "1316e03af5c31964116661ab08e7784bfa1d00b3";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "catppuccin-obsidian";
    version = "${version}-${builtins.substring 0 7 commitHash}";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "obsidian";
      rev = commitHash;
      hash = "sha256-UM2/5CkG75ABGlMI7r5sMbF0HlfMB161KyRdAHVBDrE=";
    };

    nativeBuildInputs = [
      nodejs-slim
      pnpmConfigHook
      pnpm
    ];

    buildPhase = ''
      runHook preBuild

      pnpm run build

      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/
      cp manifest.json $out/
      cp dist/catppuccin.css $out/theme.css
    '';

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 3;
      hash = "sha256-hoZeU2XMYnuW8Y9uossDfs6XPEweGa4suU7dDbSyOIk=";
    };

    meta = {
      description = "Catppuccin for Obsidian";
      homepage = "https://github.com/catppuccin/obsidian";
      changelog = "https://github.com/catppuccin/obsidian/releases/tag/v${version}";
      license = lib.licenses.mit;
    };
  })
