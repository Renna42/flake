_: final: prev: {
  # keep-sorted start block=yes
  aria2 = prev.aria2.overrideAttrs (
    new: old: {
      version = "1.37.0-11";
      src = final.fetchFromGitHub {
        owner = "AnInsomniacy";
        repo = "aria2-builder";
        rev = "v${new.version}";
        sha256 = "sha256-xbiNSg/Z+CA0x0DQfMNsWdA+TATyX6dCeW2Nf3L3Kfs=";
      };

      buildInputs =
        old.buildInputs
        ++ [
          final.openssl
          final.expat
        ];
      configureFlags =
        old.configureFlags
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
  );
  mpv-unwrapped = prev.mpv-unwrapped.override {
    inherit (final.nur-xddxdd.lantianCustomized) ffmpeg;
  };
  # keep-sorted end
}
