{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
      vpl-gpu-rt
    ];
  };

  hardware.intel-gpu-tools.enable = true;

  services.xserver.videoDrivers = ["modesetting"];

  boot.extraModprobeConfig = let
    enableGucFlag =
      if config.virtualisation.kvmgt.enable
      then 0
      else 3;
  in ''
    options i915 enable_fbc=1 enable_guc=${toString enableGucFlag}
  '';

  users.users.renna.extraGroups = [
    "video"
    "render"
  ];

  environment.variables = {
    # Default to Intel hardware decoding
    LIBVA_DRIVER_NAME = lib.mkDefault "iHD";
    VDPAU_DRIVER = lib.mkDefault "va_gl";
  };
}
