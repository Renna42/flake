{
  lib,
  pkgs,
  ...
}: let
  lumenHost = "lumen.abda.nl";
  lumenPort = "1235";
  lumenCert = pkgs.fetchurl {
    url = "https://abda.nl/lumen/hexrays.crt";
    hash = "sha256-SL+upk1NmIwneruZhbGJ1m7ksL3AqgywzTwdlutUBsA=";
  };

  luminaVariables = {
    LUMINA_TLS = "false";
    LUMINA_PRIMARY = "guest:guest@localhost:1234";
    LUMINA_PRIMARY_TLS = "false";
  };

  stunnelCfg = pkgs.writeTextFile {
    name = "stunnel-lumen.cfg";
    text = lib.generators.toINIWithGlobalSection {} {
      globalSection = {
        options = "-NO_SSLv3";
      };
      sections = {
        tls-to-plain =
          {
            client = "yes";
            accept = "127.0.0.1:1234";
            connect = "${lumenHost}:${lumenPort}";
          }
          // lib.optionalAttrs (lumenCert != null) {
            CAfile = lumenCert;
            verifyChain = "yes";
            checkHost = lumenHost;
          };
      };
    };
  };
in {
  home.sessionVariables = luminaVariables;

  systemd.user.services.stunnel-lumen = {
    Unit = {
      Description = "stunnel use to reverse-proxy Lumen for IDA Pro";
      Wants = ["network.target"];
      After = ["network.target"];
    };
    Service = {
      Type = "exec";
      Restart = "on-failure";
      RestartSec = "5s";
      ExecStart = "${pkgs.stunnel}/bin/stunnel ${stunnelCfg}";
    };
    Install.WantedBy = ["default.target"];
  };

  launchd.agents.stunnel-lumen = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        ''
          ${lib.concatMapAttrsStringSep "\n" (n: v: "launchctl setenv ${n} '${v}'") luminaVariables}
          ${pkgs.stunnel}/bin/stunnel "${stunnelCfg}"
        ''
      ];
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      ProcessType = "Background";
      RunAtLoad = true;
    };
  };
}
