{
  lib,
  pkgs,
  hostname,
  ...
}: {
  imports = [
    ./root.nix
  ];

  # Boot
  boot = {
    loader = {
      systemd-boot = {
        enable = lib.mkDefault true;
        consoleMode = "auto";
        configurationLimit = 5;
      };
      grub.enable = lib.mkDefault false;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [
      "audit=0"
      "net.ifnames=0"
    ];
    kernelPackages = pkgs.linuxPackages_xanmod_stable;
  };

  # No need for fonts and documentation on a server
  documentation.man.enable = true;
  documentation.dev.enable = false;
  documentation.doc.enable = false;
  documentation.nixos.enable = false;
  fonts.fontconfig.enable = false;

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
  programs.git.enable = true;

  networking = {
    hostName = hostname;
    useNetworkd = true;
    useDHCP = false;
    firewall = {
      enable = lib.mkDefault true;
    };
  };
  systemd.network.enable = true;
  services.resolved.enable = false;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
  };

  systemd = {
    # Given that our systems are headless, emergency mode is useless.
    # We prefer the system to attempt to continue booting so
    # that we can hopefully still access it remotely.
    enableEmergencyMode = false;

    # For more detail, see:
    #   https://0pointer.de/blog/projects/watchdog.html
    settings.Manager = {
      # systemd will send a signal to the hardware watchdog at half
      # the interval defined here, so every 10s.
      # If the hardware watchdog does not get a signal for 20s,
      # it will forcefully reboot the system.
      RuntimeWatchdogSec = "20s";
      # Forcefully reboot if the final stage of the reboot
      # hangs without progress for more than 30s.
      # For more info, see:
      #   https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdShutdownWatchdog
      RebootWatchdogSec = "30s";
      # Forcefully reboot when a host hangs after kexec.
      # This may be the case when the firmware does not support kexec.
      KExecWatchdogSec = "1m";
    };
  };

  # use TCP BBRv3 has significantly increased throughput and reduced latency for connections
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq_codel";
    "net.ipv4.tcp_congestion_control" = "bbr3";
  };
}
