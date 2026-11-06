{
  symlinkJoin,
  nur,
  oh-my-rime,
  rime-custom-pinyin-dictionary,
  rime-moetype,
  rime-renna-custom,
  rime-zhwiki,
}: let
  rimeDataPkgs = [
    nur.repos.jetcookies.rime-lmdg
    oh-my-rime
    rime-custom-pinyin-dictionary
    rime-moetype
    rime-renna-custom
    rime-zhwiki
  ];
in
  symlinkJoin {
    name = "rime-data";
    paths = rimeDataPkgs;
    passthru = {
      inherit rimeDataPkgs;
    };
  }
