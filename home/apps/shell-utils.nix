{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.nix-index-database.homeModules.nix-index];

  home.packages = with pkgs; [
    # keep-sorted start
    aria2
    asciinema
    cachix
    chafa
    chroma
    delta
    duf
    dust
    fastfetch
    git-msgraph
    glow
    moor
    nexttrace
    nix-output-monitor
    nix-update
    nixpkgs-review
    nurl
    qrencode
    tre-command
    wget
    yq-go
    # keep-sorted end
  ];

  home.sessionVariables = {
    # VSCodium required this to sign commits
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };

  # Command-line Apps
  programs.git = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux
      then pkgs.git.override {withLibsecret = true;}
      else pkgs.git;
    lfs.enable = true;
    signing = {
      key = ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGB2uuw6/tQo99cUQWzgwqP0KdPagwceBBgOYTVejhyI Renna Zhou
      '';
      format = "ssh";
      signByDefault = true;
    };
    settings = let
      email = "is@renna.dev";
    in {
      user = {
        inherit email;
        name = "Renna Z.";
      };
      sendemail = {
        sendmailCmd = "git-msgraph";
        from = email;
      };
      credential.helper = lib.optionalString pkgs.stdenv.isLinux "libsecret";
      core.autocrlf = "input";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
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
    settings = {
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
    extraConfig = ''
      Host 10.22.0.1
        HostKeyAlgorithms=+ssh-rsa
    '';
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
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
      export GITHUB_TOKEN_CMD="gh auth token"
      export GITHUB_TOKEN="$(gh auth token)"
      export NIX_CONFIG="extra-access-tokens = github.com=$GITHUB_TOKEN"

      export PAGER="moor"
    '';
    shellAliases = {
      co = "codium .";
      dt = "${pkgs.coreutils}/bin/date --iso-8601=seconds | tee /dev/stderr | fish_clipboard_copy";
      tree = "tre";
      issh = "kitten ssh";
      icat = "kitten icat";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "https";
    };
  };

  # programs.tirith = {
  #   enable = true;
  #   enableFishIntegration = true;
  # };

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

  programs.fzf.enable = true;

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
    content = lib.generators.toDhall {} {
      authToken = config.sops.placeholder.cachix_auth_token;
      hostname = "https://cachix.org";
    };
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
