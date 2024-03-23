{
  lib,
  config,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
in
{
  imports = [ inputs.apple-silicon.nixosModules.apple-silicon-support ];

  options.olivia.asahi.enable = mkEnableOption "Asahi Linux settings";

  config =
    {
      hardware.asahi.enable = mkDefault false;
    }
    // mkIf config.olivia.asahi.enable {
      nixpkgs.overlays = mkDefault [ outputs.overlays.apple-silicon ];
      hardware.asahi = {
        enable = mkDefault true;
        useExperimentalGPUDriver = mkDefault true;
      };
    };
}
