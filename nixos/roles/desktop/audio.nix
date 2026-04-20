{pkgs, ...}: {
  # Enable sound with pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    lowLatency = {
      enable = true;
      alsa.enable = true;
    };
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    alsa-utils
  ];
}
