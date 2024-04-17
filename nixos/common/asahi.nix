{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkDefault
    mkForce
    mkMerge
    ;
in
{
  imports = [ inputs.apple-silicon.nixosModules.apple-silicon-support ];

  options.olivia.asahi.enable = mkEnableOption "Asahi Linux settings";

  config = mkMerge [
    { hardware.asahi.enable = mkDefault false; }
    (mkIf config.olivia.asahi.enable {
      hardware.asahi = {
        enable = mkForce true;
        useExperimentalGPUDriver = mkDefault true;
        experimentalGPUInstallMode = mkDefault "overlay";
      };
      boot.loader.efi.canTouchEfiVariables = mkForce false;
    })
  ];
}
