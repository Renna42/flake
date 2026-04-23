_: final: prev: {
  sources = import ../_sources/generated.nix {
    inherit (prev) fetchgit fetchurl fetchFromGitHub dockerTools;
  };
}
