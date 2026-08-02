{
  secretsPath,
  pkgs,
  unstablePkgs,
  lib,
  config,
  ...
}: let
  # https://github.com/openai/codex/issues/14599#issuecomment-4098754431
  codexWrapper = pkgs.writers.writePython3Bin "codex" {} ''
    import json
    import os
    import sys
    from pathlib import Path


    CODEX = "${lib.getExe config.programs.codex.package}"


    def main() -> None:
        project = json.dumps(str(Path.cwd()))
        config = f'projects={{{project}={{trust_level="trusted"}}}}'
        os.execvp(CODEX, [CODEX, "-c", config, *sys.argv[1:]])


    if __name__ == "__main__":
        main()
  '';
in {
  sops.secrets.codex_api_key = {
    format = "json";
    sopsFile = "${secretsPath}/codex.json";
    key = "api_key";
  };
  sops.templates."auth.json" = {
    content = lib.generators.toJSON {} {
      auth_mode = "apikey";
      OPENAI_API_KEY = config.sops.placeholder.codex_api_key;
    };
    path = "${config.home.homeDirectory}/.codex/auth.json";
  };

  home.packages = [
    (lib.hiPrio codexWrapper)
    pkgs.rtk
  ];

  programs.mcp = {
    enable = true;
    servers = {};
  };

  programs.codex = {
    enable = true;
    package = unstablePkgs.codex;
    enableMcpIntegration = true;

    settings = {
      analytics.enabled = false;
      feedback.enabled = false;
      check_for_update_on_startup = false;
      default_permissions = "workspace_filtered";

      model_provider = "ksm";
      model = "gpt-5.6-sol";
      review_model = "gpt-5.6-sol";
      model_reasoning_effort = "high";
      disable_response_storage = true;
      network_access = "enabled";
      preferred_auth_method = "apikey";
      model_providers.ksm = {
        name = "KSM";
        base_url = "https://api.ksm.moe/v1";
        wire_api = "responses";
        request_max_retries = 99;
        stream_max_retries = 99;
      };

      permissions = {
        workspace_filtered = {
          extends = ":workspace";
          filesystem = {
            glob_scan_max_depth = 6;
            ":workspace_roots" = {
              ".env" = "deny";
              "**/.env" = "deny";
              ".decrypted*" = "deny";
            };
          };
        };
      };

      tui = {
        show_tooltips = false;
        theme = "catppuccin-macchiato";
      };
    };
  };

  # home.file.".roo/rules".source = ./rules;
}
