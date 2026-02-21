{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };

  services.xserver.videoDrivers = ["modesetting"];

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
}
