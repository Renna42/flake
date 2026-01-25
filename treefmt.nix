_: {
  projectRootFile = ".git/config";

  programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    statix = {
      enable = true;
      disabled-lints = ["repeated_keys" "faster_zipattrswith"];
    };
    keep-sorted.enable = true;
  };

  settings.deadnix.options = ["--edit" "--no-lambda-arg" "--no-lambda-pattern-names"];
}
