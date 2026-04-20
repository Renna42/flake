{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = false;
      nvidiaPersistenced = true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    VDPAU_DRIVER = "nvidia";

    # For hwdec to work on firefox
    NVD_BACKEND = "direct";
  };

  environment.systemPackages = [
    pkgs.nvtopPackages.full
  ];

  virtualisation.docker.enableNvidia = true;
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia-container-toolkit.suppressNvidiaDriverAssertion = true;
}
