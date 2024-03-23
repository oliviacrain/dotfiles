{
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];

  networking.hostName = "corvus";
  olivia.enable = true;

  nixpkgs.overlays = [
    outputs.overlays.apple-silicon
  ];

  hardware.asahi.useExperimentalGPUDriver = true;

  programs.zsh.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  system.stateVersion = "24.05";
}
