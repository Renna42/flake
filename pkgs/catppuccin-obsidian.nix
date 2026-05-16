{
  stdenv,
  lib,
  pkgs,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "catppuccin-obsidian";
  version = "2.0.4";

  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "obsidian";
    rev = "065101797eb32eea61ef7b6690e7b9ff7cbf08d9";
    hash = "sha256-sN5k263geOtJ1mOCQGM8UdmA/71OhBI5NRwGxJwd80E=";
  };

  nativeBuildInputs = with pkgs; [
    nodejs
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

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-u1hhAw8zOUllUstg1Mfg/czCUIuuR1IiuLr759iSZH0=";
  };

  meta = {
    description = "Catppuccin for Obsidian";
    homepage = "https://github.com/catppuccin/obsidian";
    changelog = "https://github.com/catppuccin/obsidian/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})
