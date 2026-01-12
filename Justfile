default: switch

inspect:
    nix run github:bluskript/nix-inspect -- -p .

build:
    nh os build .

switch: && home-switch
    nh os switch .

boot:
    nh os boot .

dryrun:
    nixos-rebuild dry-run --flake . --sudo -v --log-format internal-json |& nom --json

darwin-switch: && home-switch
    nh darwin switch .

home-switch:
    nh home switch .

gc:
    # remove all generations older than 7 days
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

    # garbage collect all unused nix store entries
    sudo nix store gc --debug

update:
    nix flake update
