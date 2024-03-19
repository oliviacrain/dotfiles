{ lib, inputs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
