{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  options.olivia.tailscale.enable = mkEnableOption "common tailscale settings";

  config = mkIf config.olivia.tailscale.enable {
    services.tailscale = {
      enable = mkDefault true;
      useRoutingFeatures = mkDefault "client";
    };
    # https://github.com/tailscale/tailscale/issues/11504
    systemd.services.tailscaled.postStart = "${pkgs.coreutils}/bin/timeout 60s ${pkgs.bash}/bin/bash -c 'until ${config.services.tailscale.package}/bin/tailscale status; do sleep 1; done'";
    networking.firewall = {
      enable = mkDefault true;
      trustedInterfaces = mkDefault ["tailscale0"];
      allowedUDPPorts = mkDefault [config.services.tailscale.port];
      allowedTCPPorts = mkDefault [22];
    };
  };
}
