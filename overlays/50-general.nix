_: final: prev: {
  splayer-next = prev.splayer-next.overrideAttrs (
    new: old: {
      version = "1.2.0-alpha.1";

      src = prev.fetchFromGitHub {
        owner = "SPlayer-Dev";
        repo = "SPlayer-Next";
        tag = "v${new.version}";
        hash = "sha256-Xa395CzMVymwNxeL3oBoTVFfe+8fs8SgZJHHq59Nk7Q=";
      };

      pnpmDeps = old.pnpmDeps.override {
        inherit (new) version src;
        hash = "sha256-4Q5aiTjqU1W+NP5atV9cCsmjIMBGc+9bqhVQ8/TvDkc=";
      };
    }
  );
}
