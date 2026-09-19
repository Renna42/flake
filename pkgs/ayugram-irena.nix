{
  ayugram-desktop,
  sources,
}:
ayugram-desktop.overrideAttrs (new: old: {
  inherit (sources.ayugram-irena) src;

  pname = "ayugram-irena";
  version = "7.1.2-unstable-${sources.ayugram-irena.date or sources.ayugram-irena.verison}";
})
