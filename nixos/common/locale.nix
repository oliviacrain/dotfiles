{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
in
{
  options.olivia.locale.enable = mkEnableOption "common locale settings";

  config = mkIf config.olivia.locale.enable {
    time.timeZone = mkDefault "America/Chicago";
    i18n.defaultLocale = mkDefault "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = mkDefault "en_US.UTF-8";
      LC_IDENTIFICATION = mkDefault "en_US.UTF-8";
      LC_MEASUREMENT = mkDefault "en_US.UTF-8";
      LC_MONETARY = mkDefault "en_US.UTF-8";
      LC_NAME = mkDefault "en_US.UTF-8";
      LC_NUMERIC = mkDefault "en_US.UTF-8";
      LC_PAPER = mkDefault "en_US.UTF-8";
      LC_TELEPHONE = mkDefault "en_US.UTF-8";
      LC_TIME = mkDefault "en_US.UTF-8";
    };
  };
}
