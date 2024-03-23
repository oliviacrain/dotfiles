{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
in
{
  options.olivia.nvidia.enable = mkEnableOption "common nvidia settings";

  config = mkIf config.olivia.nvidia.enable {
    hardware.nvidia = {
      modesetting.enable = mkDefault true;
      powerManagement.enable = mkDefault false;
      powerManagement.finegrained = mkDefault false;
      open = mkDefault false;
      nvidiaSettings = mkDefault true;
    };
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
