{
  lib,
  fetchFromGitHub,
  rustPlatform,
}: let
  harlettyBridgeVersion = "0.8.0";
  omniphonyVersion = "0.6.0";
in
  rustPlatform.buildRustPackage (finalAttrs: {
    pname = "harletty-bridge";
    version = harlettyBridgeVersion;

    srcs = [
      (fetchFromGitHub {
        name = finalAttrs.pname;
        owner = "harletty";
        repo = "harletty-bridge";
        tag = "v${harlettyBridgeVersion}";
        hash = "sha256-TaBBc+Mei1g+PoDIROTgoO5/YjqdeQ3t/SWeqAIYlNw=";
      })
      (fetchFromGitHub {
        name = "Omniphony";
        owner = "mgth";
        repo = "Omniphony";
        tag = "v${omniphonyVersion}";
        hash = "sha256-u3BXSdgP766ao9IVmh4N6h1/GRg6Uatt/dlzU0W+fII=";
      })
    ];

    sourceRoot = finalAttrs.pname;

    cargoHash = "sha256-+Pe4przofxcwoVsvf4Pj8Y1M1ZrSFIjjYv8QVnpIr8c=";

    env.VERGEN_GIT_DESCRIBE = finalAttrs.version;

    meta = {
      description = "Dolby TrueHD / E-AC-3 (Atmos) decoder bridge plugin for the Omniphony renderer";
      homepage = "https://github.com/harletty/harletty-bridge";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        Renna42
      ];
      mainProgram = "harletty";
      platforms = lib.platforms.unix;
    };
  })
