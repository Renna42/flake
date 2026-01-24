{config, ...}: {
  sops = {
    secrets.authropic_auth_token = {};
    secrets.authropic_base_url = {};
    templates."claude-session-vars.sh" = {
      content = ''
        export ANTHROPIC_AUTH_TOKEN="${config.sops.placeholder.authropic_auth_token}"
        export ANTHROPIC_BASE_URL="${config.sops.placeholder.authropic_base_url}"
        export ANTHROPIC_MODEL="claude-sonnet-4-5-20250929"
      '';
    };
  };

  programs.claude-code = {
    enable = true;
    settings = {
      hooks = {
        PostToolUse = [
          {
            hooks = [
              {
                command = "nix fmt $(jq -r '.tool_input.file_path' &lt;&lt;&lt; '$CLAUDE_TOOL_INPUT')";
                type = "command";
              }
            ];
            matcher = "Edit|MultiEdit|Write";
          }
        ];
        PreToolUse = [
          {
            hooks = [
              {
                command = "echo 'Running command: $CLAUDE_TOOL_INPUT'";
                type = "command";
              }
            ];
            matcher = "Bash";
          }
        ];
      };
      includeCoAuthoredBy = false;
      alwaysThinkingEnabled = false;
      permissions = {
        allow = [
          "Bash(git diff:*)"
          "Edit"
        ];
        ask = [
          "Bash(git push:*)"
        ];
        defaultMode = "acceptEdits";
        deny = [
          "WebFetch"
          "Bash(curl:*)"
          "Read(./.env)"
          "Read(./secrets/**)"
        ];
        disableBypassPermissionsMode = "disable";
      };
      statusLine = {
        command = "input=$(cat); echo \"[$(echo \"$input\" | jq -r '.model.display_name')] 📁 $(basename \"$(echo \"$input\" | jq -r '.workspace.current_dir')\")\"";
        padding = 0;
        type = "command";
      };
      theme = "dark";
    };
  };

  home.sessionVariablesExtra = ''
    source ${config.sops.templates."claude-session-vars.sh".path}
  '';
}
