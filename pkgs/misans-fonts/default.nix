{
  lib,
  stdenvNoCC,
  symlinkJoin,
  fetchzip,
}: let
  version = "0-unstable-2023-10-31";
  meta = {
    description = "MiSans font family by Xiaomi";
    homepage = "https://hyperos.mi.com/font";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.all;
  };
  makeMisansFont = {
    pname,
    url,
    hash,
  }:
    stdenvNoCC.mkDerivation {
      inherit
        pname
        meta
        version
        ;

      src = fetchzip {
        inherit url hash;
        extension = "zip";
        stripRoot = false;
      };

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        find . -name "*.otf" -exec install -Dm444 -t "$out/share/fonts/opentype" {} +
        find . -name "*.ttf" -exec install -Dm444 -t "$out/share/fonts/truetype" {} +

        runHook postInstall
      '';
    };
  variants = [
    {
      pname = "misans";
      url = "https://hyperos.mi.com/font-download/MiSans.zip";
      hash = "sha256-MH4t7oXDUiH1TAm0xKa0AENmB1zoedd8X5BcQFNw8GM=";
    }
    {
      pname = "misans-latin";
      url = "https://hyperos.mi.com/font-download/MiSans_Latin.zip";
      hash = "sha256-TNgy0JgYAr8CqYKE6y78p0F3r+jMIKau1dtQdX8lsN4=";
    }
    {
      pname = "misans-tc";
      url = "https://hyperos.mi.com/font-download/MiSans_TC.zip";
      hash = "sha256-1yuDRuPEzNQfNrgAGfQqrw/p+9QC/fV/sf17vEj48Ac=";
    }
    {
      pname = "misans-l3";
      url = "https://hyperos.mi.com/font-download/MiSans_L3.zip";
      hash = "sha256-Hooruq+g2AyMRONuRh5QJnXTx5IxnkFlRYY/oPbKNug=";
    }
    {
      pname = "misans-tibetan";
      url = "https://hyperos.mi.com/font-download/MiSans_Tibetan.zip";
      hash = "sha256-67v6PeAa64Ab3QUX4qXM+bDc2MgiSRrmDcEblC+5UH4=";
    }
    {
      pname = "misans-arabic";
      url = "https://hyperos.mi.com/font-download/MiSans_Arabic.zip";
      hash = "sha256-NVls20QVvY8gtY1Kj9JsCJ1g1q+kHdt2ELwq2LUbtO8=";
    }
    {
      pname = "misans-devanagari";
      url = "https://hyperos.mi.com/font-download/MiSans_Devanagari.zip";
      hash = "sha256-4xqpAjvQ4mJN0VH/M37wb7ytyLIU83plnbCQhpbPj1Q=";
    }
    {
      pname = "misans-gurmukhi";
      url = "https://hyperos.mi.com/font-download/MiSans_Gurmukhi.zip";
      hash = "sha256-TEAOHslx6XP/OognOMifAa1n5Y0gLulVumL1uQhuK00=";
    }
    {
      pname = "misans-thai";
      url = "https://hyperos.mi.com/font-download/MiSans_Thai.zip";
      hash = "sha256-trtQvWcCaDaksT/nOTX5deFO4vwEKaVXGSN8bBEohXc=";
    }
    {
      pname = "misans-lao";
      url = "https://hyperos.mi.com/font-download/MiSans_Lao.zip";
      hash = "sha256-4dhR7savVOvyehwqvq7VakJRSPxB9iQKu2jX8XuiadI=";
    }
    {
      pname = "misans-myanmar";
      url = "https://hyperos.mi.com/font-download/MiSans_Myanmar.zip";
      hash = "sha256-Y/Uux6AZKdD8J92cW0Tn6h27EK/nrOS1agP/e321/NI=";
    }
    {
      pname = "misans-khmer";
      url = "https://hyperos.mi.com/font-download/MiSans_Khmer.zip";
      hash = "sha256-v+SuL8RSax80uikxRC/xmuhftnqVYtkNq9AGVbjDPjI=";
    }
  ];

  variantPkgs = map makeMisansFont variants;
in
  builtins.listToAttrs (map (pkg: {
      name = pkg.pname;
      value = pkg;
    })
    variantPkgs)
  // {
    misans-all = symlinkJoin {
      inherit meta version;
      pname = "misans-all";
      paths = variantPkgs;
    };
  }
