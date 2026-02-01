{
  fetchzip,
  proton-ge-bin,
}:
proton-ge-bin.overrideAttrs (
  finalAttrs: _previousAttrs: {
    pname = "dwproton-bin";
    version = "10.0-15";

    steamDisplayName = "dwproton";

    src = fetchzip {
      url = "https://dawn.wine/dawn-winery/dwproton/releases/download/dwproton-${finalAttrs.version}/dwproton-${finalAttrs.version}-x86_64.tar.xz";
      hash = "sha256-Z59F/iLFM4CG7VAmGg74H7dpFhA4QveZgnXrkkUtwTI=";
    };
  }
)
