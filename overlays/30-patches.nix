_: final: prev: {
  tirith = prev.tirith.overrideAttrs (new: _old: {
    version = "0.4.1";
    src = prev.fetchFromGitHub {
      owner = "sheeki03";
      repo = "tirith";
      tag = "v${new.version}";
      hash = "sha256-RUGiWQ0+xC2gFz6B1PN+eUwD6bhRE0q7eLa7aw9Phdc=";
    };

    cargoHash = "sha256-MYYAltyAFFt1BSkOwWpMEKw5rzQfduzDG7JcBEzKbOg=";
    ## workaround for overrideAttrs on buildRustPackage
    ## see https://discourse.nixos.org/t/is-it-possible-to-override-cargosha256-in-buildrustpackage/4393/3
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      name = "${new.pname}-cargo-deps";
      inherit (new) src patches;
      hash = new.cargoHash;
    };

    doCheck = false;
    doInstallCheck = false;
  });

  rsgain = prev.rsgain.overrideAttrs (new: old: {
    version = "3.8";
    src = prev.fetchFromGitHub {
      owner = "complexlogic";
      repo = "rsgain";
      rev = "v${new.version}";
      hash = "sha256-BhjsTGSxemFX0MYSDUgKqX9W8ScLyq8Y6OhagMO6m70=";
    };
  });
}
