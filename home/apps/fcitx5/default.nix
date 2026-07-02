{pkgs, ...}: let
  fcitx5-rime-with-addons =
    (pkgs.fcitx5-rime.override {
      librime = pkgs.nur-xddxdd.lantianCustomized.librime-with-plugins;
      rimeDataPkgs = with pkgs; [
        renna.rime-data
        rime-data
      ];
    }).overrideAttrs
    (old: {
      # Prebuild schema data
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.parallel];
      postInstall =
        (old.postInstall or "")
        + ''
          for F in $out/share/rime-data/*.schema.yaml; do
            echo "rime_deployer --compile "$F" $out/share/rime-data $out/share/rime-data $out/share/rime-data/build" >> parallel.lst
          done
          parallel -j$(nproc) < parallel.lst || true
        '';
    });
in {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime-with-addons
        fcitx5-mozc-ut
        kdePackages.fcitx5-qt
      ];
    };
  };
}
