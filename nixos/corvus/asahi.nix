{inputs, outputs, pkgs, lib,...}:{
    imports = [inputs.apple-silicon.nixosModules.apple-silicon-support];
    hardware.asahi = {
      enable = true;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      peripheralFirmwareDirectory = builtins.toString (
        pkgs.runCommand "asahi-firmware-corvus-extracted" {} ''
          mkdir -p $out
          tar xf "${pkgs.asahi-firmware-corvus}" -C "$out"
        ''
      );
    };
    boot.loader.efi.canTouchEfiVariables = false;
    nixpkgs.overlays = lib.mkBefore [outputs.overlays.widevine];
    environment.sessionVariables.MOZ_GMP_PATH = [
      "${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed"
    ];
}
