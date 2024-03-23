{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
in
{
  options.olivia.desktop = {
    enable = mkEnableOption "common desktop settings";
  };

  config = mkIf config.olivia.desktop.enable {
    services.xserver = {
      enable = mkDefault true;
      displayManager.sddm = {
        enable = mkDefault true;
        wayland.enable = mkDefault true;
      };
    };

    services.desktopManager.plasma6 = {
      enable = mkDefault true;
      enableQt5Integration = mkDefault false;
    };

    services.printing.enable = mkDefault true;

    sound.enable = mkDefault true;
    hardware.pulseaudio.enable = mkDefault false;
    security.rtkit.enable = mkDefault true;
    services.pipewire = {
      enable = mkDefault true;
      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
    };
  };
}
