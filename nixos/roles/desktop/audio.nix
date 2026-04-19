_: {
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
      quantum = 64;
      rate = 768000;
      alsa = {
        enable = true;
        devicePattern = "~alsa_output.usb-SMSL_SMSL_USB_AUDIO-00.*";
      };
    };
  };

  security.rtkit.enable = true;
}
