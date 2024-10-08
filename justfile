local := `hostname -s`
impure-system-build := if local == "corvus" {"--impure"} else {""}

build-system-local: sources-to-store
    nom build {{justfile_directory()}}#nixosConfigurations.{{local}}.config.system.build.toplevel --keep-going {{impure-system-build}}

switch: build-system-local
    sudo nixos-rebuild switch --flake {{justfile_directory()}}#{{local}} {{impure-system-build}}

diff: build-system-local
    nvd diff /run/current-system {{justfile_directory()}}/result

check:
    nix run github:DeterminateSystems/flake-checker

update:
    nix flake update --commit-lock-file --option commit-lockfile-summary "Update flake.lock"

deploy hostname: sources-to-store
    nix run nixpkgs#nixos-rebuild -- \
        switch \
        --fast --flake {{justfile_directory()}}#{{hostname}} \
        --target-host {{hostname}} --build-host {{hostname}} \
        --use-remote-sudo --show-trace

# :/
# https://github.com/NixOS/nixfmt/issues/151
# https://github.com/NixOS/nix/issues/9359
fmt:
    nix fmt \
        ./flake.nix \
        ./home-manager \
        ./nixos \
        ./overlays \
        ./templates \
        ./pkgs/{asahi-firmware-corvus,berkeley-mono,default,to-the-sky-background,witchhazel}.nix

sources-to-store:
    nix-prefetch-url --type sha256 file://{{justfile_directory()}}/sources/berkeley-mono-typeface.zip
    nix-prefetch-url --type sha256 file://{{justfile_directory()}}/sources/to-the-sky.jpg
    if [[ "{{local}}" == "corvus" ]]; then nix-prefetch-url --type sha256 file://{{justfile_directory()}}/sources/asahi-firmware-corvus/asahi-firmware-corvus.tar; fi
