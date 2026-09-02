{
  config,
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
      branch = "bleeding_edge";
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

  users.users.renna.extraGroups = [
    "video"
    "render"
  ];

  virtualisation.docker.enableNvidia = true;
  hardware.nvidia-container-toolkit = {
    enable = true;
    suppressNvidiaDriverAssertion = true;
  };

  systemd.services.nvidia-mps = {
    description = "NVIDIA CUDA Multi-Process Service";
    after = ["nvidia-persistenced.service"];
    requires = ["nvidia-persistenced.service"];
    wantedBy = ["multi-user.target"];
    path = [config.hardware.nvidia.package.bin];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-cuda-mps-control -d";
      ExecStop = "${pkgs.writeShellScript "nvidia-mps-stop" ''
        echo quit | ${config.hardware.nvidia.package.bin}/bin/nvidia-cuda-mps-control
      ''}";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
