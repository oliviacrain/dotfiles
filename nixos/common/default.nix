{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
in {
  imports = [
    ./nix.nix

    ./boot.nix
    ./desktop.nix
    ./locale.nix
    ./network.nix
    ./olivia.nix
    ./sops.nix
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
    };
  };
}
