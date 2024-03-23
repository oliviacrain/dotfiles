{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
in
{
  options.olivia.tailscale.enable = mkEnableOption "common tailscale settings";

  config = mkIf config.olivia.tailscale.enable {
    services.tailscale = {
      enable = mkDefault true;
      useRoutingFeatures = mkDefault "client";
    };
    networking.firewall = {
      enable = mkDefault true;
      trustedInterfaces = mkDefault [ "tailscale0" ];
      allowedUDPPorts = mkDefault [ config.services.tailscale.port ];
      allowedTCPPorts = mkDefault [ 22 ];
    };
  };
}
