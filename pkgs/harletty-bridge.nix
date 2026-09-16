{
  lib,
  fetchFromGitHub,
  rustPlatform,
}: let
  harlettyBridgeVersion = "0.7.4";
  omniphonyVersion = "0.5.2";
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
        hash = "sha256-ZjtBam0wdIGbM6dqYymezHH0cKY/MXRN9UUtxLgOf30=";
      })
      (fetchFromGitHub {
        name = "Omniphony";
        owner = "mgth";
        repo = "Omniphony";
        tag = "v${omniphonyVersion}";
        hash = "sha256-kldkxnYR27Rnxa4UEqUh9e1HLp6x5XSsA+s33KinKlY=";
      })
    ];

    sourceRoot = finalAttrs.pname;

    cargoHash = "sha256-qce6EA6Ltk0fzL7aT0Zy4O08nXU9A9XIMl4La3QhPOU=";

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
