{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  options.olivia.boot.enable = mkEnableOption "boot settings";

  config = mkIf config.olivia.boot.enable {
    boot.loader = {
      systemd-boot.enable = mkDefault true;
      efi.canTouchEfiVariables = mkDefault false;
    };
  };
}
