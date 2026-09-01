_: final: prev: {
  ddcci-driver = prev.ddcci-driver.overrideAttrs (oldAttrs: {
    patches =
      [
        (prev.fetchpatch {
          name = "Use-sysfs_emit-and-field-width-specifier.patch";
          url = "https://gitlab.com/liquidnya/ddcci-driver-linux/-/commit/9510aa4aebf32678884f55ae251e54012a354ed1.patch";
          hash = "sha256-s12ers7nPFaHOB+8/S8t3dtdoR6slukkfNPdghgftNs=";
        })
      ]
      ++ (oldAttrs.patches or []);
  });
}
