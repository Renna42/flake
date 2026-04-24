{
  assetsPath,
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  oh-my-rime = pkgs.callPackage ./oh-my-rime.nix {};
  rime-moetype = pkgs.callPackage ./rime-moetype.nix {};
  rime-zhwiki = pkgs.callPackage ./rime-zhwiki.nix {};
  rime-renna-custom = pkgs.callPackage ./rime-renna-custom.nix {inherit assetsPath config;};
  rimeDataPkgs = [
    oh-my-rime
    rime-moetype
    rime-zhwiki
    rime-renna-custom
  ];
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
    source = "${
      pkgs.symlinkJoin {
        name = "rime-data";
        paths = rimeDataPkgs;
      }
    }/share/rime-data";
    recursive = true;
  };
}
