local := `hostname -s`
default_deploy_mode := "switch"

# Flake operations

check:
    nix flake check

fmt:
    nix fmt

update:
    nix flake update --commit-lock-file --option commit-lockfile-summary "Update flake.lock"

# System building

sources-to-store:
    nix-prefetch-url --type sha256 file://{{ justfile_directory() }}/sources/berkeley-mono-typeface.zip
    nix-prefetch-url --type sha256 file://{{ justfile_directory() }}/sources/to-the-sky.jpg

build-system hostname=local: sources-to-store
    nom build {{ justfile_directory() }}#nixosConfigurations.{{ hostname }}.config.system.build.toplevel --keep-going

diff: build-system
    nvd diff /run/current-system {{ justfile_directory() }}/result

# Deployment
deploy hostname=local mode=default_deploy_mode: (build-system hostname)
    nix run nixpkgs#nixos-rebuild -- \
        {{ mode }} \
        --fast --flake {{ justfile_directory() }}#{{ hostname }} \
        --target-host {{ hostname }} --build-host {{ hostname }} \
        --use-remote-sudo --show-trace
