{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
in
{
  imports = [
    ./nix.nix

    ./asahi.nix
    ./boot.nix
    ./desktop.nix
    ./locale.nix
    ./minecraft.nix
    ./network.nix
    ./nvidia.nix
    ./olivia.nix
    ./tailscale.nix
    ./vscode-server.nix

    ./home-manager.nix
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
      minecraft.enable = mkDefault false;
      nvidia.enable = mkDefault false;
    };
  };
}
