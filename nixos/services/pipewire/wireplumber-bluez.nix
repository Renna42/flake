{pkgs, ...}: {
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextFile {
      name = "wireplumber-bluez-config";
      text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]",
          ["bluez5.codecs"] = "[ sbc sbc_xq aac ldac aptx aptx_hd aptx_ll aptx_ll_duplex faststream faststream_duplex lc3plus_h3 opus_05 opus_05_51, opus_05_71 opus_05_duplex opus_05_pro lc3 ]",
        }
      '';
      destination = "/share/wireplumber/bluetooth.lua.d/51-bluez-config.lua";
    })
  ];
}
