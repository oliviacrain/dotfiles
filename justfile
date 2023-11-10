switch:
    home-manager switch --flake {{justfile_directory()}}#olivia@corvus

check:
    nix run github:DeterminateSystems/flake-checker

update:
    nix flake update --commit-lock-file --option commit-lockfile-summary "Update flake.lock"