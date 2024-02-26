local := `hostname -s`

switch:
    nom build --impure {{justfile_directory()}}#nixosConfigurations.{{local}}.config.system.build.toplevel
    sudo nixos-rebuild switch --impure --flake {{justfile_directory()}}#{{local}}

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

font-to-store:
    nix-prefetch-url --type sha256 file://{{justfile_directory()}}/pkgs/berkeley-mono-typeface.zip
