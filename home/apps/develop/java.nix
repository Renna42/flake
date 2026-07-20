{pkgs, ...}: let
  myjdk = pkgs.temurin-bin-21;
in {
  home.packages = with pkgs; [
    maven
  ];

  programs.java = {
    enable = true;
    package = myjdk;
  };

  programs.gradle = {
    enable = true;
    settings = {
      "org.gradle.home" = myjdk;
      "org.gradle.jvmargs" = "-Xmx2G";
      "org.gradle.caching" = true;
      "org.gradle.parallel" = true;
    };
  };

  programs.vscodium.profiles.default.userSettings = {
    "java.jdt.ls.java.home" = "${myjdk}/lib/openjdk";
  };
}
