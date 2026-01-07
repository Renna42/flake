{pkgs, ...}: {
  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "Maple Mono Normal NF CN";
        package = pkgs.maple-mono.Normal-NF-CN-unhinted;
      }
      {
        name = "Unifont";
        package = pkgs.unifont;
      }
    ];
    hwRender = true;
  };
}
