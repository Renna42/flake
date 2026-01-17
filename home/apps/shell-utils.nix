{
  lib,
  config,
  pkgs,
  platform,
  ...
}: let
  sshAuthSock =
    if platform.isDarwin
    then "${config.home.homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
    else "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
in {
  home.packages = with pkgs; [
    any-nix-shell
    fastfetch
    nix-output-monitor # https://github.com/maralorn/nix-output-monitor
    dust
    duf
    asciinema
    delta
    chroma
    moor
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

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  programs.direnv-instant = {
    enable = true;
    enableFishIntegration = true;
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
      export SSH_AUTH_SOCK="${sshAuthSock}"
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
    enable = true;
    enableFishIntegration = true;
    enableSshSupport = true;
    pinentry.package =
      if platform.isLinux
      then pkgs.pinentry-qt
      else pkgs.pinentry_mac;
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
