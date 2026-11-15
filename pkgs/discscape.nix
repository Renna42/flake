{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "discscape";
  version = "0-unstable-2026-11-14";

  src = fetchFromGitHub {
    owner = "Isoheptane";
    repo = "discscape";
    rev = "3c11cd127324a4ddb590a4e1d5816613df11d909";
    hash = "sha256-GmKHSak6koDfaAl4B7YDQUm1HxMS3qBwYh0yTqhHn6c=";
  };

  cargoHash = "sha256-xRm/nHvRm+TJG2YAueGkVLavyI7wJ7Ot8DzFzK4yzmE=";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };

  meta = {
    description = "Paint visible image on optical discs (CD)";
    homepage = "https://github.com/Isoheptane/discscape";
    license = lib.licenses.mit;
    mainProgram = "discscape";
    maintainers = with lib.maintainers; [
      Renna42
    ];
    platforms = lib.platforms.unix;
  };
})
