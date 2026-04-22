_: final: prev: {
  generated = import ./_sources/generated.nix {
    inherit (prev) fetchgit fetchurl fetchFromGitHub dockerTools;
  };
}
