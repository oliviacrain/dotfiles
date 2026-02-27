{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  options.olivia.network.enable = mkEnableOption "common network settings";

  config = mkIf config.olivia.network.enable {
    services.resolved.enable = mkDefault true;
    networking = {
      networkmanager = {
        enable = mkDefault true;
        wifi.backend = mkDefault "iwd";
      };
      wireless.iwd = {
        enable = mkDefault true;
        settings.General.EnableNetworkConfiguration = mkDefault true;
      };
    };
  };
}
