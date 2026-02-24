{
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # keep-sorted start
    any-nix-shell
    asciinema
    cachix
    chroma
    delta
    duf
    dust
    fastfetch
    moor
    nix-output-monitor
    omnix
    qrencode
    yq-go
    # keep-sorted end
  ];

  # Command-line Apps
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user = {
        name = "Renna Z.";
        email = "is@renna.dev";
        signingKey = "96763FAE10AC74FC";
      };
      core.autocrlf = "input";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgSign = true;
      tag.gpgSign = true;
      alias.ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      hyperlinks = true;
      hyperlinks-file-link-format = "vscode://file/{path}:{line}";
      true-color = "always";
      side-by-side = true;
      line-numbers = true;
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableTransience = true;
  };

  home.file."${config.xdg.configHome}/starship.toml".source = lib.mkForce ./configs/starship.toml;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      "github.com" = {
        forwardAgent = true;
      };
      "git.dn42.dev" = {
        forwardAgent = true;
      };
      "git.asnk.io" = {
        forwardAgent = true;
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.direnv-instant = {
    enable = true;
    enableFishIntegration = true;
    settings.mux_delay = 2;
  };

  programs.fish = {
    enable = true;
    plugins = map (x: {inherit (x) name src;}) (
      with pkgs.fishPlugins; [
        plugin-git
        fzf-fish
        puffer
      ]
    );
    shellInit = "set -g fish_greeting";
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source

      if test -x /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv | source
      end

      ${lib.optionalString config.programs.kitty.enable ''
        alias s="kitten ssh"
      ''}

      export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
      export GITHUB_TOKEN_CMD="gh auth token"
      export GO111MODULE="on"
      export GOPROXY="https://goproxy.cn"
    '';
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "https";
    };
  };

  # Replace command-not-found with nix-index and comma
  programs.nix-index-database.comma.enable = true;
  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.lsd = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.vivid = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat.enable = true;

  programs.btop.enable = true;

  programs.jq.enable = true;

  programs.ripgrep.enable = true;

  programs.fd = {
    enable = true;
    ignores = [
      ".git/"
      "node_modules/"
    ];
  };

  programs.tealdeer.enable = true;

  # Cachix
  sops.secrets.cachix_auth_token = {};
  sops.templates."cachix.dhall" = {
    content = ''
      { authToken =
          "${config.sops.placeholder.cachix_auth_token}"
      , hostname = "https://cachix.org"
      , binaryCaches = [] : List { name : Text, secretKey : Text }
      }
    '';
    path = "${config.home.homeDirectory}/.config/cachix/cachix.dhall";
  };

  # programs.zellij = {
  #   enable = true;
  # };

  # xdg.configFile."zellij/config.kdl".source = ./externalConfigs/zellij-config.kdl;

  programs.gpg = {
    enable = true;
    # https://github.com/nix-community/home-manager/issues/5383, shame on you!
    settings = lib.mkForce {
      ask-cert-level = true;
      keyserver-options = [
        "no-self-sigs-only"
        "no-import-clean"
      ];
      armor = true;
    };
  };

  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    enableFishIntegration = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  home.file.".gnupg/dirmngr.conf".text =
    lib.generators.toKeyValue
    {
      mkKeyValue = key: value: (
        if lib.isString value
        then "${key} ${value}"
        else lib.optionalString value key
      );
      listsAsDuplicateKeys = true;
    }
    {
      keyserver = "hkps://keyserver.ubuntu.com";
      # https://github.com/rvm/rvm/issues/4215#issuecomment-435228758
      disable-ipv6 = true;
    };
}
