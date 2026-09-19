_: final: prev: {
  tirith = prev.tirith.overrideAttrs (new: _old: {
    version = "0.4.2";
    src = prev.fetchFromGitHub {
      owner = "sheeki03";
      repo = "tirith";
      tag = "v${new.version}";
      hash = "sha256-5feylgprI/k+Y3dNeEdl3/TpNBdvjRA6u8RjD4eMQP4=";
    };

    cargoHash = "sha256-J58LW86QbSU4us6MCq8I0Oh8+uSHsSigEQwsXVNu4LU=";
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

  splayer-next = prev.splayer-next.overrideAttrs (new_: old: {
    postPatch =
      (old.postPatch or "")
      + ''
        cpalDevice="$(find "$cargoDepsCopy" \
          -path '*/cpal-0.18.2/src/host/pipewire/device.rs' -print)"
        if [ ! -f "$cpalDevice" ]; then
          echo "Expected exactly one CPAL 0.18.2 PipeWire device.rs" >&2
          exit 1
        fi
        substituteInPlace "$cpalDevice" --replace-fail \
          'properties.insert("node.group", format!("cpal-{}", std::process::id()));' \
          'properties.insert("node.group", format!("cpal-{}", std::process::id()));
          if matches!(direction, DeviceDirection::Output) {
              properties.insert(
                  *pw::keys::NODE_RATE,
                  format!("1/{}", config.sample_rate),
              );
          }'
      '';
  });
}
