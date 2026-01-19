_: {
  hardware.printers = {
    ensurePrinters = [
      {
        name = "EPSON_L8168";
        location = "Home";
        deviceUri = "dnssd://EPSON%20L8168._ipp._tcp.local/?uuid=cfe92100-67c4-11d4-a45f-64c6d25cd34e";
        model = "everywhere";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "EPSON_L8168";
  };
}
