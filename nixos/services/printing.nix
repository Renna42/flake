{pkgs, ...}: {
  services.printing = {
    enable = true;
    startWhenNeeded = false;
    drivers = with pkgs; [
      foomatic-db
      foomatic-db-engine
      foomatic-db-nonfree
      foomatic-db-ppds-withNonfreeDb
      foomatic-filters
      gutenprint
      gutenprintBin
      epson-escpr2
    ];

    cups-pdf = {
      enable = true;
      instances.cups-pdf = {
        installPrinter = true;
        settings.Out = "/var/lib/cups-pdf";
      };
    };
  };

  services.system-config-printer.enable = true;

  systemd.services.cups.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "3";
  };

  systemd.services.cups-browsed.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "3";
  };

  systemd.tmpfiles.settings = {
    cups-pdf = {
      "/var/lib/cups-pdf"."d" = {
        mode = "755";
        user = "root";
        group = "root";
      };
    };
  };
}
