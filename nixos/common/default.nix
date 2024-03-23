{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
in
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

  options = {
    olivia.enable = mkEnableOption "Olivia's nixos modules";
  };

  config = mkIf config.olivia.enable {
    olivia = {
      desktop.enable = mkDefault true;
      locale.enable = mkDefault true;
      nix.enable = mkDefault true;
      network.enable = mkDefault true;
      tailscale.enable = mkDefault true;
    };
  };
}
