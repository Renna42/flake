_: final: prev: {
  openldap = prev.openldap.overrideAttrs {
    doCheck = false;
  };
}
