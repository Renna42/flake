{
  description = "Renna's System Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
      "https://renna42.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "renna42.cachix.org-1:AqHSiL2lFKYHYJ0U2YFiW1kjItvFMmyyc6loFZR3/X8="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    betterfox-nix = {
      url = "github:HeitorAugustoLN/betterfox-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chinese-fonts-overlay = {
      url = "github:brsvh/chinese-fonts-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "github:petrkozorezov/firefox-addons-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    flat-flake = {
      url = "github:linyinfeng/flat-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks-nix";
      inputs.systems.follows = "systems";
    };
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
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-xddxdd = {
      url = "github:xddxdd/nur-packages";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nix-index-database.follows = "nix-index-database";
      inputs.nix-cachyos-kernel.follows = "nix-cachyos-kernel";
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
      url = "github:nix-community/stylix";
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

    overlays = nixpkgs.lib.attrValues self.overlays;
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
          inputs.home-manager.flakeModules.home-manager
          flakeModules.renna-treefmt
          flakeModules.renna-git-hooks
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
            inherit system;
            config.allowUnfree = true;
          };
        in {
          legacyPackages = adjustLegacyPackages (self.lib.makePackages pkgs' ./pkgs {});
          packages = flake-utils.lib.flattenTree self'.legacyPackages;

          overlayAttrs = {
            renna = lib.recurseIntoAttrs self'.legacyPackages;
            generated = import ./_sources/generated.nix {
              inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;
            };
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
            nix-alien = inputs.nix-alien.overlays.default;
            nix-cachyos-kernel = inputs.nix-cachyos-kernel.overlays.pinned;
            nix-gaming = inputs.nix-gaming.overlays.default;
            nix4vscode = inputs.nix4vscode.overlays.default;
            nixpkgs-wayland = inputs.nixpkgs-wayland.overlay;
            nur = inputs.nur.overlays.default;
            rust-overlay = inputs.rust-overlay.overlays.default;
            # keep-sorted end
          };

          lib = import ./lib {inherit (nixpkgs) lib;};

          nixosConfigurations = lib.genAttrs nixosMachines (
            hostname:
              self.lib.withOfflineInstaller {
                flake = self;
                nixosConfig = nixpkgs.lib.nixosSystem {
                  specialArgs =
                    globalSpecialArgs
                    // {
                      inherit hostname;
                    };
                  modules = [
                    ./configurations/${hostname}
                    ./nixos/common
                    # keep-sorted start
                    inputs.angrr.nixosModules.angrr
                    inputs.disko.nixosModules.disko
                    inputs.home-manager.nixosModules.home-manager
                    inputs.hyprland.nixosModules.default
                    inputs.nix-gaming.nixosModules.pipewireLowLatency
                    inputs.nix-gaming.nixosModules.platformOptimizations
                    inputs.nix-gaming.nixosModules.wine
                    inputs.nur-xddxdd.nixosModules.openssl-conf
                    inputs.nur-xddxdd.nixosModules.openssl-gost-engine
                    inputs.nur-xddxdd.nixosModules.openssl-oqs-provider
                    inputs.nur-xddxdd.nixosModules.qemu-user-static-binfmt
                    inputs.nur-xddxdd.nixosModules.setupOverlay
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
            hostname:
              inputs.darwin.lib.darwinSystem {
                specialArgs =
                  globalSpecialArgs
                  // {
                    inherit hostname;
                  };
                modules = [
                  ./darwin
                  inputs.home-manager.darwinModules.home-manager
                  inputs.sops-nix.darwinModules.sops
                ];
              }
          );
        };
      }
    );
}
