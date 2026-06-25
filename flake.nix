{
  description = "Renna's System Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://attic.xuyh0120.win/lantian"
      "https://renna42.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "renna42.cachix.org-1:AqHSiL2lFKYHYJ0U2YFiW1kjItvFMmyyc6loFZR3/X8="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    systems.url = "github:nix-systems/default";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # keep-sorted start block=yes
    angrr = {
      url = "github:linyinfeng/angrr";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nix-darwin.follows = "darwin";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    betterfox-nix = {
      url = "github:HeitorAugustoLN/betterfox-nix";
      inputs.flake-parts.follows = "flake-parts";
      inputs.import-tree.follows = "import-tree";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chinese-fonts-overlay = {
      url = "github:brsvh/chinese-fonts-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crane.url = "github:ipetkov/crane";
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "github:xddxdd/firefox-addons-nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flat-flake = {
      url = "github:linyinfeng/flat-flake";
      inputs.crane.follows = "crane";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.systems.follows = "systems";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gitignore-nix = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-nixos = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.pre-commit-hooks.follows = "git-hooks-nix";
    #   inputs.systems.follows = "systems";
    # };
    import-tree.url = "github:denful/import-tree";
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-index-database.follows = "nix-index-database";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks.follows = "git-hooks-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4vscode = {
      url = "github:nix-community/nix4vscode";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-nixcord.follows = "nixpkgs";
    };
    nixfmt-rs = {
      url = "github:Mic92/nixfmt-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-xddxdd = {
      url = "github:xddxdd/nur-packages";
      inputs.devshell.follows = "devshell";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nix-cachyos-kernel.follows = "nix-cachyos-kernel";
      inputs.nix-index-database.follows = "nix-index-database";
      inputs.nixfmt-rs.follows = "nixfmt-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "git-hooks-nix";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nur.follows = "nur";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keep-sorted end
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    flake-utils,
    ...
  } @ inputs: let
    assetsPath = ./assets;
    secretsPath = ./secrets;

    overlays = (nixpkgs.lib.attrValues self.overlays) ++ import ./overlays {};
    globalSpecialArgs = {
      inherit
        inputs
        assetsPath
        secretsPath
        overlays
        ;
    };
    nixosMachines = [
      "Mizuka"
      "Quebec"
      "Shirobako"
    ];
    darwinMachines = ["Schwarzschild"];

    deployLib = inputs.deploy-rs.lib;
  in
    flake-parts.lib.mkFlake {inherit inputs;} (
      {
        flake-parts-lib,
        lib,
        ...
      }: let
        inherit (flake-parts-lib) importApply;
        flakeModules = {
          renna-treefmt = importApply ./flake-modules/renna-treefmt.nix {inherit (inputs) treefmt-nix;};
          renna-git-hooks = importApply ./flake-modules/renna-git-hooks.nix {inherit (inputs) git-hooks-nix;};
        };
      in {
        imports = [
          inputs.flake-parts.flakeModules.easyOverlay
          inputs.flat-flake.flakeModules.flatFlake
          flakeModules.renna-treefmt
          flakeModules.renna-git-hooks
        ];

        flatFlake.config.allowed = [
          # keep-sorted start block=yes
          ["hyprland" "aquamarine"]
          ["hyprland" "hyprcursor"]
          ["hyprland" "hyprgraphics"]
          ["hyprland" "hyprland-guiutils" "hyprtoolkit"]
          ["hyprland" "hyprland-guiutils"]
          ["hyprland" "hyprland-protocols"]
          ["hyprland" "hyprlang"]
          ["hyprland" "hyprutils"]
          ["hyprland" "hyprwayland-scanner"]
          ["hyprland" "hyprwire"]
          ["hyprland" "xdph"]
          ["nix-cachyos-kernel" "cachyos-kernel"]
          ["nix-cachyos-kernel" "cachyos-kernel-patches"]
          ["stylix" "base16" "fromYaml"]
          ["stylix" "base16"]
          ["stylix" "base16-fish"]
          ["stylix" "base16-helix"]
          ["stylix" "base16-vim"]
          ["stylix" "firefox-gnome-theme"]
          ["stylix" "gnome-shell"]
          ["stylix" "tinted-kitty"]
          ["stylix" "tinted-schemes"]
          ["stylix" "tinted-tmux"]
          ["stylix" "tinted-zed"]
          # keep-sorted end
        ];

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];
        perSystem = {
          self',
          pkgs,
          config,
          system,
          ...
        }: let
          # rename `self.legacyPackages.*.packages` -> `self.legacyPackages.*.packages'`
          # `self.legacyPackages.*.packages` collides with `self.packages` in nix cli
          adjustLegacyPackages = pkgs:
            lib.attrsets.removeAttrs pkgs ["packages"]
            // {packages' = pkgs.packages;};

          pkgs' = import self.inputs.nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
        in {
          legacyPackages = adjustLegacyPackages (self.lib.makePackages pkgs' ./pkgs {});
          packages = flake-utils.lib.flattenTree self'.legacyPackages;

          overlayAttrs = {
            renna = lib.recurseIntoAttrs self'.legacyPackages;
          };

          checks = deployLib.deployChecks self'.deploy;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              # keep-sorted start
              config.treefmt.build.wrapper
              deploy-rs
              disko
              just
              nh
              nix
              nix-output-monitor
              nixd
              nvfetcher
              openssh
              sops
              ssh-to-age
              statix
              # keep-sorted end
            ];
            inherit (config.pre-commit) shellHook;
            buildInputs = config.pre-commit.settings.enabledPackages;
            EDITOR = "codium -w";
          };
        };

        flake = {
          overlays = {
            # keep-sorted start
            angrr = inputs.angrr.overlays.default;
            chinese-fonts-overlay = inputs.chinese-fonts-overlay.overlays.default;
            firefox-addons = inputs.firefox-addons.overlays.default;
            flat-flake = inputs.flat-flake.overlays.default;
            nix-alien = inputs.nix-alien.overlays.default;
            nix-cachyos-kernel = inputs.nix-cachyos-kernel.overlays.pinned;
            nix-gaming = inputs.nix-gaming.overlays.default;
            nix4vscode = inputs.nix4vscode.overlays.default;
            nur = inputs.nur.overlays.default;
            nur-xddxdd = inputs.nur-xddxdd.overlays.inSubTree-pinnedNixpkgs;
            rust-overlay = inputs.rust-overlay.overlays.default;
            # keep-sorted end
          };

          lib = import ./lib {inherit (nixpkgs) lib;};

          nixosConfigurations = lib.genAttrs nixosMachines (
            hostname: let
              system =
                if hostname == "Quebec"
                then "aarch64-linux"
                else "x86_64-linux";
              unstablePkgs = import inputs.nixpkgs-unstable {
                inherit system overlays;
                config.allowUnfree = true;
              };
            in
              self.lib.withOfflineInstaller {
                flake = self;
                nixosConfig = nixpkgs.lib.nixosSystem {
                  specialArgs =
                    globalSpecialArgs
                    // {
                      inherit hostname unstablePkgs;
                    };
                  modules = [
                    ./configurations/${hostname}
                    ./nixos/common
                    # keep-sorted start
                    inputs.angrr.nixosModules.angrr
                    inputs.disko.nixosModules.disko
                    inputs.home-manager-nixos.nixosModules.home-manager
                    # inputs.hyprland.nixosModules.default
                    inputs.nix-gaming.nixosModules.platformOptimizations
                    inputs.nix-gaming.nixosModules.wine
                    inputs.nur-xddxdd.nixosModules.openssl-conf
                    inputs.nur-xddxdd.nixosModules.openssl-gost-engine
                    inputs.nur-xddxdd.nixosModules.openssl-oqs-provider
                    inputs.nur-xddxdd.nixosModules.qemu-user-static-binfmt
                    inputs.sops-nix.nixosModules.sops
                    inputs.stylix.nixosModules.stylix
                    # keep-sorted end
                  ];
                };
              }
          );

          deploy.nodes = lib.genAttrs nixosMachines (
            hostname: {
              inherit hostname;
              sshUser = "root";
              profiles.system = {
                user = "root";
                path = deployLib.x86_64-linux.activate.nixos self.nixosConfigurations."${hostname}";
              };
            }
          );

          darwinConfigurations = lib.genAttrs darwinMachines (
            hostname: let
              system = "aarch64-darwin";
              unstablePkgs = import inputs.nixpkgs-unstable {
                inherit system overlays;
                config.allowUnfree = true;
              };
            in
              inputs.darwin.lib.darwinSystem {
                specialArgs =
                  globalSpecialArgs
                  // {
                    inherit hostname unstablePkgs;
                  };
                modules = [
                  ./darwin
                  inputs.home-manager-darwin.darwinModules.home-manager
                  inputs.sops-nix.darwinModules.sops
                ];
              }
          );
        };
      }
    );
}
