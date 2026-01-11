{
  lib,
  stdenvNoCC,
  fetchzip,
  symlinkJoin,
}: let
  meta = {
    description = "MiSans font family by Xiaomi";
    homepage = "https://hyperos.mi.com/font";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [];
    platforms = lib.platforms.all;
  };
  mkMisansFont = {
    name,
    url,
    hash,
  }:
    stdenvNoCC.mkDerivation (
      finalAttrs: {
        inherit name meta;
        version = "0-unstable-2023-10-31";

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
      }
    );

  variants = [
    {
      name = "misans";
      url = "https://hyperos.mi.com/font-download/MiSans.zip";
      hash = "sha256-MH4t7oXDUiH1TAm0xKa0AENmB1zoedd8X5BcQFNw8GM=";
    }
    {
      name = "misans-latin";
      url = "https://hyperos.mi.com/font-download/MiSans_Latin.zip";
      hash = "sha256-TNgy0JgYAr8CqYKE6y78p0F3r+jMIKau1dtQdX8lsN4=";
    }
    {
      name = "misans-tc";
      url = "https://hyperos.mi.com/font-download/MiSans_TC.zip";
      hash = "sha256-1yuDRuPEzNQfNrgAGfQqrw/p+9QC/fV/sf17vEj48Ac=";
    }
    {
      name = "misans-l3";
      url = "https://hyperos.mi.com/font-download/MiSans_L3.zip";
      hash = "sha256-Hooruq+g2AyMRONuRh5QJnXTx5IxnkFlRYY/oPbKNug=";
    }
    {
      name = "misans-tibetan";
      url = "https://hyperos.mi.com/font-download/MiSans_Tibetan.zip";
      hash = "sha256-67v6PeAa64Ab3QUX4qXM+bDc2MgiSRrmDcEblC+5UH4=";
    }
    {
      name = "misans-arabic";
      url = "https://hyperos.mi.com/font-download/MiSans_Arabic.zip";
      hash = "sha256-NVls20QVvY8gtY1Kj9JsCJ1g1q+kHdt2ELwq2LUbtO8=";
    }
    {
      name = "misans-devanagari";
      url = "https://hyperos.mi.com/font-download/MiSans_Devanagari.zip";
      hash = "sha256-4xqpAjvQ4mJN0VH/M37wb7ytyLIU83plnbCQhpbPj1Q=";
    }
    {
      name = "misans-gurmukhi";
      url = "https://hyperos.mi.com/font-download/MiSans_Gurmukhi.zip";
      hash = "sha256-TEAOHslx6XP/OognOMifAa1n5Y0gLulVumL1uQhuK00=";
    }
    {
      name = "misans-thai";
      url = "https://hyperos.mi.com/font-download/MiSans_Thai.zip";
      hash = "sha256-trtQvWcCaDaksT/nOTX5deFO4vwEKaVXGSN8bBEohXc=";
    }
    {
      name = "misans-lao";
      url = "https://hyperos.mi.com/font-download/MiSans_Lao.zip";
      hash = "sha256-4dhR7savVOvyehwqvq7VakJRSPxB9iQKu2jX8XuiadI=";
    }
    {
      name = "misans-myanmar";
      url = "https://hyperos.mi.com/font-download/MiSans_Myanmar.zip";
      hash = "sha256-Y/Uux6AZKdD8J92cW0Tn6h27EK/nrOS1agP/e321/NI=";
    }
    {
      name = "misans-khmer";
      url = "https://hyperos.mi.com/font-download/MiSans_Khmer.zip";
      hash = "sha256-hR8F8X7P5egsUIhUaT9yrYSHzqwEgvbQj0gnEgKxw4k=";
    }
  ];

  variantPkgs = map mkMisansFont variants;
in
  lib.listToAttrs (map (pkg: {
      inherit (pkg) name;
      value = pkg;
    })
    variantPkgs)
  // {
    misans-all = symlinkJoin {
      inherit meta;
      name = "misans-all";
      paths = variantPkgs;
    };
  }
