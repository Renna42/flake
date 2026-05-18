{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  cmake,
  pkg-config,
  openssl,
  expat,
  c-ares,
  zlib,
  sqlite,
  libssh2,
  libuv,
  jemalloc,
  cppunit,
  nixosTests,
  withLibuv ? true,
  withJemalloc ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aria2-next";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "AnInsomniacy";
    repo = "aria2-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qNTZqjZUp2+HVHe6CrHB/yeniR/CnklehBTlLzLBWt0=";
  };

  nativeBuildInputs = [
    installShellFiles
    cmake
    pkg-config
  ];

  buildInputs =
    [
      openssl
      expat
      c-ares
      zlib
      sqlite
      libssh2
      libuv
      jemalloc
    ]
    ++ lib.optionals withLibuv [
      libuv
    ]
    ++ lib.optionals withJemalloc [
      jemalloc
    ];

  configureFlags =
    [
      "-DARIA2_ENABLE_LIBARIA2=ON"
      "-DARIA2_WITH_GNUTLS=OFF"
      "-DARIA2_WITH_OPENSSL=ON"
      "-DARIA2_WITH_LIBXML2=OFF"
      "-DARIA2_WITH_EXPAT=ON"
      "-DARIA2_WITH_CARES=ON"
      "-DARIA2_WITH_ZLIB=ON"
      "-DARIA2_WITH_SQLITE3=ON"
      "-DARIA2_WITH_LIBSSH2=ON"
      "-DARIA2_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "-DARIA2_WITH_GMP=OFF"
      "-DARIA2_WITH_LIBGCRYPT=OFF"
      "-DARIA2_WITH_LIBNETTLE=OFF"
    ]
    ++ lib.optionals withLibuv [
      "-DARIA2_WITH_LIBUV=ON"
    ]
    ++ lib.optionals withJemalloc [
      "-DARIA2_WITH_JEMALLOC=ON"
    ];

  nativeCheckInputs = [cppunit];
  doCheck = false; # needs the net

  enableParallelBuilding = true;

  postInstall = ''
    installShellCompletion --bash $src/docs/completion/aria2-next
  '';

  passthru.tests = {
    inherit (nixosTests) aria2;
  };

  meta = {
    homepage = "https://github.com/AnInsomniacy/aria2-next";
    changelog = "https://github.com/AnInsomniacy/aria2-next/releases/tag/v${finalAttrs.version}";
    description = "aria2 fork with extensive bug fixes, modernized architecture, full compatibility, and reproducible releases";
    mainProgram = "aria2-next";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      Renna42
    ];
  };
})
