{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
in
{
  imports = [
    ./asahi.nix
    ./boot.nix
    ./desktop.nix
    ./home-manager.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./nvidia.nix
    ./olivia.nix
    ./tailscale.nix
    ./vscode-server.nix
  ];

  options = {
    olivia.enable = mkEnableOption "Olivia's nixos modules";
  };

  config = mkIf config.olivia.enable {
    olivia = {
      boot.enable = mkDefault true;
      desktop.enable = mkDefault true;
      home-manager.enable = mkDefault true;
      locale.enable = mkDefault true;
      network.enable = mkDefault true;
      nix.enable = mkDefault true;
      tailscale.enable = mkDefault true;
      vscode-server.enable = mkDefault true;

      asahi.enable = mkDefault false;
      nvidia.enable = mkDefault false;
    };
  };
}
