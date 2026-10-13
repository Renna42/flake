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
  version = "0.4.51";
  commitHash = "7ebbd577464d6ef8a18cb02811983bee623f30d6";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "catppuccin-obsidian";
    version = "${version}-${builtins.substring 0 7 commitHash}";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "obsidian";
      rev = commitHash;
      hash = "sha256-9IwQsXFf63/R27xazFKzkVhPSgTnlYtNzb9uUY3WRa8=";
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
      hash = "sha256-H5cYntTaP28RclCGAM3nRrUJIt6NFOwBW+kC1KWLEHU=";
    };

    meta = {
      description = "Catppuccin for Obsidian";
      homepage = "https://github.com/catppuccin/obsidian";
      changelog = "https://github.com/catppuccin/obsidian/releases/tag/v${version}";
      license = lib.licenses.mit;
    };
  })
