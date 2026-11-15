{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  validatePkgConfig,
  pkg-config,
  pipewire,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "orender";
  version = "0.7.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "mgth";
    repo = "Omniphony";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kBE1EY34RhNI2ATo/sj81oWZZn6L63S/Zqz1SycUVOE=";
  };

  cargoRoot = "omniphony-renderer";
  buildAndTestSubdir = "omniphony-renderer";

  cargoHash = "sha256-gHKIh6dcj1RMS9s1Ni29b8tkPTEMebODppdJsxoEAKo=";

  cargoBuildFlags = [
    "-p"
    "omniphony-renderer"
    "-p"
    "orender_ffi"
  ];

  cargoCheckFlags = [
    "-p"
    "omniphony-renderer"
    "-p"
    "orender_ffi"
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    validatePkgConfig
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pipewire
  ];

  postPatch = ''
    grep -rl '/usr/share/orender/layouts' omniphony-renderer | while read -r f; do
      substituteInPlace "$f" --replace-fail '/usr/share/orender/layouts' "$out/share/orender/layouts"
    done
  '';

  postInstall =
    ''
      mkdir -p "$lib/lib"
      mv "$out/lib/liborender"* "$lib/lib/"
      rmdir "$out/lib"

      install -Dm644 omniphony-renderer/orender_ffi/include/orender.h "$dev/include/orender.h"
      install -Dm644 omniphony-renderer/orender_ffi/orender.pc.in "$dev/lib/pkgconfig/orender.pc"
      substituteInPlace "$dev/lib/pkgconfig/orender.pc" \
        --replace-fail "@PREFIX@" "$out" \
        --replace-fail "@VERSION@" "${finalAttrs.version}"
      sed -i -E \
        -e "s|^libdir=.*|libdir=$lib/lib|" \
        -e "s|^includedir=.*|includedir=$dev/include|" \
        "$dev/lib/pkgconfig/orender.pc"

      install -Dm644 layouts/*.yaml -t "$out/share/orender/layouts"
      install -Dm644 layouts/legacy/*.yaml -t "$out/share/orender/layouts/legacy"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 packaging/systemd/omniphony-renderer.service -t "$out/lib/systemd/user"
      substituteInPlace "$out/lib/systemd/user/omniphony-renderer.service" \
        --replace-warn "/usr/bin/orender" "$out/bin/orender"
    '';

  meta = {
    description = "Bridge-driven spatial audio decoding and rendering";
    homepage = "https://github.com/mgth/Omniphony";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      Renna42
    ];
    mainProgram = "orender";
  };
})
