{
  lib,
  fetchFromGitHub,
  rustPlatform,
}: let
  commitDate = "2026-11-09";
  commitHash = "a6151612071fabc1ea2c30dedd4a55ecf7d79a1c";
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "discscape";
    version = "0.1.0-unstable-${commitDate}";

    src = fetchFromGitHub {
      owner = "Isoheptane";
      repo = "discscape";
      rev = commitHash;
      hash = "sha256-cjD6yteazoByPMTSkhw4+3L/FQANlJtCNHdyCZbYQOs=";
    };

    cargoHash = "sha256-xRm/nHvRm+TJG2YAueGkVLavyI7wJ7Ot8DzFzK4yzmE=";

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
