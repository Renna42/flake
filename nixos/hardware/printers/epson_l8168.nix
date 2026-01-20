{pkgs, ...}: {
  services.printing.drivers = [
    pkgs.epson-escpr2
  ];

  hardware.printers = {
    ensurePrinters = [
      {
        name = "EPSON_L8168";
        location = "Home";
        deviceUri = "lpd://10.22.0.200:515/PASSTHRU";
        model = "epson-inkjet-printer-escpr2/Epson-L8160_Series-epson-escpr2-en.ppd";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
    ensureDefaultPrinter = "EPSON_L8168";
  };
}
