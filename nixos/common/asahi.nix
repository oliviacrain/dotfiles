{
  lib,
  pkgs,
  config,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkDefault
    mkForce
    mkMerge
    mkBefore
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
        experimentalGPUInstallMode = mkDefault "replace";
        peripheralFirmwareDirectory = builtins.toString (
          pkgs.runCommand "asahi-firmware-corvus-extracted" { } ''
            mkdir -p $out
            tar xf "${pkgs.asahi-firmware-corvus}" -C "$out"
          ''
        );
      };
      boot.loader.efi.canTouchEfiVariables = mkForce false;
      nixpkgs.overlays = mkBefore [ outputs.overlays.widevine ];
      environment.sessionVariables.MOZ_GMP_PATH = [
        "${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed"
      ];
    })
  ];
}
