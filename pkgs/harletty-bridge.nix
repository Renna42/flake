{
  lib,
  fetchFromGitHub,
  rustPlatform,
}: let
  harlettyBridgeVersion = "0.9.0";
  omniphonyVersion = "0.7.0";
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
        hash = "sha256-bAA7CEM73TXyjTDMwvm6aUKsdHTQCLsDYF984eGN4fY=";
      })
      (fetchFromGitHub {
        name = "Omniphony";
        owner = "mgth";
        repo = "Omniphony";
        tag = "v${omniphonyVersion}";
        hash = "sha256-kBE1EY34RhNI2ATo/sj81oWZZn6L63S/Zqz1SycUVOE=";
      })
    ];

    sourceRoot = finalAttrs.pname;

    cargoHash = "sha256-V5ha4nxkDF5torSjyL4WZ04WzeURkBSKJ7DhoVDcGDo=";

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
