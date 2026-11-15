{
  lib,
  fetchFromGitHub,
  rustPlatform,
  orender,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "harletty-bridge";
  version = "0.9.0";

  outputs = [
    "out"
    "lib"
  ];

  srcs = [
    (fetchFromGitHub {
      name = finalAttrs.pname;
      owner = "harletty";
      repo = "harletty-bridge";
      tag = "v${finalAttrs.version}";
      hash = "sha256-bAA7CEM73TXyjTDMwvm6aUKsdHTQCLsDYF984eGN4fY=";
    })
    orender.src
  ];

  sourceRoot = finalAttrs.pname;

  postUnpack = ''
    mv "${orender.src.name}" Omniphony
  '';

  cargoHash = "sha256-V5ha4nxkDF5torSjyL4WZ04WzeURkBSKJ7DhoVDcGDo=";

  env.VERGEN_GIT_DESCRIBE = finalAttrs.version;

  postInstall = ''
    mkdir -p "$lib"
    mv "$out/lib" "$lib/"
  '';

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
