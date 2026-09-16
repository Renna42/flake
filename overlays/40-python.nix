_: final: prev: {
  python3Packages = prev.python3Packages.overrideScope (
    new: old: {
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/development/python-modules/silero-vad/default.nix
      # This package not exists in nixos-26.05
      silero-vad = old.buildPythonPackage (finalAttrs: {
        pname = "silero-vad";
        version = "6.2.1";
        pyproject = true;

        src = prev.fetchFromGitHub {
          owner = "snakers4";
          repo = "silero-vad";
          tag = "v${finalAttrs.version}";
          hash = "sha256-peGaJkSqjeobgx479OKt8ErorFviTIA7naFPewgab4U=";
        };

        build-system = [
          old.hatchling
        ];

        dependencies = [
          old.packaging
          old.torch
          old.torchaudio
        ];

        # tests use torchcodec which refuses to decode tests/data/test.mp3
        # this causes all tests to fail. See https://github.com/snakers4/silero-vad/issues/777
        doCheck = false;
      });
    }
  );
}
