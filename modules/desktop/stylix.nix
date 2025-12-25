{assetsPath, ...}: {
  stylix = {
    enable = true;
    base16Scheme = "${assetsPath}/themes/onedark.yaml";
    targets.console.enable = false;
  };
}
