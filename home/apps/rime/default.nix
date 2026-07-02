{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  rimeConfig =
    if pkgs.stdenv.isDarwin
    then "Library/Rime"
    else if config.i18n.inputMethod.type == "fcitx5"
    then ".local/share/fcitx5/rime"
    else throw "Unsupported input method type: ${config.i18n.inputMethod.type}";
  installationCustom = ''
    sync_dir: "${config.home.homeDirectory}/.rime-sync"
    installation_id: "${osConfig.networking.hostName}"
  '';

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
  i18n.inputMethod.fcitx5.addons = [
    fcitx5-rime-with-addons
  ];

  home.activation.patchRimeInstallation = lib.hm.dag.entryAfter ["writeBoundary"] ''
    target="${config.home.homeDirectory}/${rimeConfig}/installation.yaml"
    if [ -e "$target" ]; then
      ${pkgs.yq-go}/bin/yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' "$target" - --inplace <<EOF
    ${installationCustom}
    EOF
    fi
  '';
  home.file.${rimeConfig} = lib.mkIf pkgs.stdenv.isDarwin {
    source = "${pkgs.renna.rime-data}/share/rime-data";
    recursive = true;
  };
}
