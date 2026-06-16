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
    else if osConfig.i18n.inputMethod.type == "fcitx5"
    then ".local/share/fcitx5/rime"
    else if osConfig.i18n.inputMethod.type == "ibus"
    then ".config/ibus/rime"
    else throw "unable to determine rime config directory";
  installationCustom = ''
    sync_dir: "${config.home.homeDirectory}/.rime-sync"
    installation_id: "${osConfig.networking.hostName}"
  '';
in {
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
