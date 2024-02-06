local := `hostname -s`

switch:
    if [ '{{local}}' == 'corvus'  ]; then \
        home-manager switch --flake {{justfile_directory()}}#olivia@{{local}}; \
    else \
        nixos-rebuild switch --flake {{justfile_directory()}}#{{local}}; \
    fi

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
