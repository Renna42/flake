{
  fetchFromGitHub,
  aria2,
  openssl,
  expat,
}:
aria2.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "aria2-mn";
    version = "1.37.0-11";
    src = fetchFromGitHub {
      owner = "AnInsomniacy";
      repo = "aria2-builder";
      rev = "v${finalAttrs.version}";
      sha256 = "sha256-xbiNSg/Z+CA0x0DQfMNsWdA+TATyX6dCeW2Nf3L3Kfs=";
    };

    buildInputs =
      previousAttrs.buildInputs
      ++ [
        openssl
        expat
      ];
    configureFlags =
      previousAttrs.configureFlags
      ++ [
        "--without-gnutls"
        "--with-openssl"
        "--without-libxml2"
        "--with-libexpat"
        "--with-libcares"
        "--with-libz"
        "--with-sqlite3"
        "--with-libssh2"
        "--disable-nls"
      ];
  }
)
