{
  fetchzip,
  proton-ge-bin,
}:
proton-ge-bin.overrideAttrs (finalAttrs: {
  pname = "dwproton-bin";
  version = "10.0-18";

  steamDisplayName = "dwproton";

  src = fetchzip {
    url = "https://dawn.wine/dawn-winery/dwproton/releases/download/dwproton-${finalAttrs.version}/dwproton-${finalAttrs.version}-x86_64.tar.xz";
    hash = "sha256-v87DiRf/NFMeDa0D9Td24zIZOvU5fIZ5JfNfLSAYGXc=";
  };
})
