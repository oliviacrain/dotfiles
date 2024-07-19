{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  options.olivia.network.enable = mkEnableOption "common network settings";

  config = mkIf config.olivia.network.enable {
    networking.networkmanager.enable = mkDefault true;
    networking.networkmanager.wifi.backend = mkDefault "iwd";
    networking.wireless.iwd.enable = mkDefault true;
    networking.wireless.iwd.settings.General.EnableNetworkConfiguration = mkDefault true;

    # https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  };
}
