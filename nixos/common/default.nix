{ config, ... }:
{
  imports = [
    ./desktop.nix
    ./network.nix
    ./locale.nix
    ./nix.nix
    ./olivia.nix
    ./packages.nix
    ./tailscale.nix
  ];
}
