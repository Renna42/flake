_: final: prev: {
  splayer-next = prev.splayer-next.overrideAttrs (
    new: old: {
      version = "1.2.0-unstable-2026-09-19";

      src = prev.fetchFromGitHub {
        owner = "SPlayer-Dev";
        repo = "SPlayer-Next";
        rev = "d3dd84df99333f19b04a2faef1972a89f35aee0f";
        hash = "sha256-cbHZZYq+/DNJ3+xF1SVWlTsh22el/nOp45uHjPGnL/k=";
      };

      pnpmDeps = old.pnpmDeps.override {
        inherit (new) version src;
        hash = "sha256-wYQnp76oCjpirj5VOQKmPmXxkyraJAFcShUQK7cCXY0=";
      };
    }
  );
}
