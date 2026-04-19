{
  lib,
  fetchFromGitHub,
  aegisub,
}: let
  programVersion = "3.4.1";
  tag = "migration02-01";
in
  aegisub.overrideAttrs (
    finalAttrs: previousAttrs: {
      pname = "aegisub-arch1t3cht";
      version = "${programVersion}-${tag}";

      src = fetchFromGitHub {
        inherit tag;
        owner = "arch1t3cht";
        repo = "Aegisub";
        hash = "sha256-gr+7YmHEV557NcdNzDdcj/meC6dg6FLNKnsbaR9LMEw=";
      };

      postPatch =
        ''
          patchShebangs tools/combine-config.py
        ''
        + previousAttrs.postPatch;

      meta = {
        homepage = "https://github.com/arch1t3cht/Aegisub";
        description = "arch1t3cht's Aegisub \"fork\"";
        longDescription = ''
          Cross-platform advanced subtitle editor, with new feature branches.
        '';
        # The Aegisub sources are itself BSD/ISC, but they are linked against GPL'd
        # software - so the resulting program will be GPL
        license = with lib.licenses; [
          bsd3
        ];
        mainProgram = "aegisub";
        maintainers = with lib.maintainers; [
          Renna42
        ];
        platforms = lib.platforms.unix;
      };
    }
  )
