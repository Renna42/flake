{pkgs, ...}: {
  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "Maple Mono Normal NF";
        package = pkgs.maple-mono.Normal-NF;
      }
      {
        name = "Unifont";
        package = pkgs.unifont;
      }
    ];
    hwRender = true;
  };
}
