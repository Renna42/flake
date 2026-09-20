{
  ayugram-desktop,
  sources,
}:
ayugram-desktop.overrideAttrs {
  pname = "ayugram-irena";
  unwrapped = ayugram-desktop.unwrapped.overrideAttrs (new_: old_: {
    inherit (sources.ayugram-irena) src;

    pname = "ayugram-irena-unwrapped";
    version = "7.1.2-unstable-${sources.ayugram-irena.date or sources.ayugram-irena.verison}";
  });
}
