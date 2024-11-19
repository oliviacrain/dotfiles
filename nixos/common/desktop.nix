{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    mkDefault
    mkForce
    ;
  inherit (builtins) attrValues;
in {
  options.olivia.desktop.enable = mkEnableOption "common desktop settings";

  config = mkIf config.olivia.desktop.enable {
    services.displayManager.sddm = {
      enable = mkDefault true;
      wayland.enable = mkDefault true;
    };

    services.desktopManager.plasma6 = {
      enable = mkDefault true;
      enableQt5Integration = mkDefault false;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services.printing.enable = mkDefault true;

    hardware.bluetooth.enable = mkDefault true;
    hardware.pulseaudio.enable = mkForce false;
    security.rtkit.enable = mkDefault true;
    services.pipewire = {
      enable = mkDefault true;
      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
      pulse.enable = mkDefault true;
    };

    services.dbus.implementation = mkDefault "broker";

    environment.systemPackages =
      attrValues {
        inherit
          (pkgs)
          firefox
          # clamav

          #calibre
          obsidian
          ;
      }
      ++ [pkgs.kdePackages.tokodon];

    fonts.packages = [pkgs.berkeley-mono];
  };
}
