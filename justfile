local := `hostname -s`

build-system-local: sources-to-store
    nom build {{ justfile_directory() }}#nixosConfigurations.{{ local }}.config.system.build.toplevel --keep-going

switch: build-system-local
    sudo nixos-rebuild switch --flake {{ justfile_directory() }}#{{ local }}

diff: build-system-local
    nvd diff /run/current-system {{ justfile_directory() }}/result

check:
    nix run github:DeterminateSystems/flake-checker

update:
    nix flake update --commit-lock-file --option commit-lockfile-summary "Update flake.lock"

deploy hostname: sources-to-store
    nix run nixpkgs#nixos-rebuild -- \
        switch \
        --fast --flake {{ justfile_directory() }}#{{ hostname }} \
        --target-host {{ hostname }} --build-host {{ hostname }} \
        --use-remote-sudo --show-trace

fmt:
    nix fmt

sources-to-store:
    nix-prefetch-url --type sha256 file://{{ justfile_directory() }}/sources/berkeley-mono-typeface.zip
    nix-prefetch-url --type sha256 file://{{ justfile_directory() }}/sources/to-the-sky.jpg
