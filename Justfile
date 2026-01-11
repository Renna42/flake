default: switch

inspect:
    nix run github:bluskript/nix-inspect -- -p .

build:
    nh os build .

switch:
    nh os switch .
    nh home switch .

boot:
    nh os boot .

dryrun:
    nixos-rebuild dry-run --flake . --sudo -v --log-format internal-json |& nom --json

darwin-switch:
    nh darwin switch .
    nh home switch .

gc:
    # remove all generations older than 7 days
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

    # garbage collect all unused nix store entries
    sudo nix store gc --debug

update:
    nix flake update
