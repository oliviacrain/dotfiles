local := `hostname -s`

switch:
    nom build {{justfile_directory()}}#nixosConfigurations.{{local}}.config.system.build.toplevel --impure
    sudo nixos-rebuild switch --flake {{justfile_directory()}}#{{local}} --impure

check:
    nix run github:DeterminateSystems/flake-checker

update:
    nix flake update --commit-lock-file --option commit-lockfile-summary "Update flake.lock"

deploy hostname:
    nix run nixpkgs#nixos-rebuild -- \
        switch \
        --fast --flake {{justfile_directory()}}#{{hostname}} \
        --target-host {{hostname}} --build-host {{hostname}} \
        --use-remote-sudo

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
