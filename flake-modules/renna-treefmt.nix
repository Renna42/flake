{treefmt-nix, ...}: {
  imports = [treefmt-nix.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    treefmt = {
      flakeFormatter = false;
      projectRootFile = "flake.nix";

      settings = {
        formatter.deadnix.excludes = ["**/composer2nix/**"];
        global.excludes = [
          "**/_sources/**"
          "_sources/**"
          "**/deps.nix"
          "*.age"
          ".decrypted~*"
        ];
      };

      programs = {
        # keep-sorted start block=yes
        actionlint.enable = true;
        alejandra.enable = true;
        black.enable = true;
        deadnix = {
          enable = true;
          no-lambda-arg = true;
        };
        dos2unix.enable = true;
        formatjson5.enable = true;
        isort.enable = true;
        keep-sorted.enable = true;
        shfmt.enable = true;
        statix.enable = true;
        toml-sort.enable = true;
        # keep-sorted end
      };

      settings.formatter.dos2unix.excludes = ["*.reg"];
    };

    formatter = pkgs.writeShellScriptBin "treefmt-auto" ''
      for i in {1..5}; do
        echo "Running treefmt for the ''${i}th time"
        ${pkgs.lib.getExe config.treefmt.build.wrapper} --clear-cache --fail-on-change "$@" && exit 0
      done
      exit $?
    '';
  };
}
