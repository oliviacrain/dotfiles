switch:
    home-manager switch --flake {{justfile_directory()}}#olivia@corvus

check:
    nix run github:DeterminateSystems/flake-checker