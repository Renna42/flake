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

  rimeDataPkgs = with pkgs; [
    # keep-sorted start
    nur.repos.jetcookies.rime-lmdg
    renna.oh-my-rime
    renna.rime-custom-pinyin-dictionary
    renna.rime-moetype
    renna.rime-renna-custom
    renna.rime-zhwiki
    # keep-sorted end
  ];

  rime-data = pkgs.symlinkJoin {
    name = "rime-data";
    paths = rimeDataPkgs;
  };

  fcitx5-rime-with-addons =
    (pkgs.fcitx5-rime.override {inherit rimeDataPkgs;}).overrideAttrs
    (old: {
      # Prebuild schema data
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.parallel];
      postInstall =
        (old.postInstall or "")
        + ''
          export GLOG_logtostderr=1

          for F in $out/share/rime-data/*.schema.yaml; do
            rime_deployer --compile "$F" $out/share/rime-data $out/share/rime-data $out/share/rime-data/build
          done
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
    source = "${rime-data}/share/rime-data";
    recursive = true;
  };
}
