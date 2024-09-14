{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  options.olivia.network.enable = mkEnableOption "common network settings";

  config = mkIf config.olivia.network.enable {
    networking.useNetworkd = mkDefault true;
    services.resolved.enable = true;
    networking.wireless.iwd.enable = mkDefault true;
    networking.wireless.iwd.settings.General = {
      EnableNetworkConfiguration = mkDefault true;
      UseDefaultInterface = mkDefault true;
    };
  };
}
