{
  lib,
  fetchFromGitHub,
  rustPlatform,
}: let
  commitDate = "2026-11-08";
  commitHash = "8200ec08ab10f2b1eabdbb904fb34239796c3116";
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "discscape";
    version = "0.1.0-unstable-${commitDate}";

    src = fetchFromGitHub {
      owner = "Isoheptane";
      repo = "discscape";
      rev = commitHash;
      hash = "sha256-/iaWY1h4AaG4VTIluEy7Yam1Q2//cv8BFTKkLaAzsfI=";
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
