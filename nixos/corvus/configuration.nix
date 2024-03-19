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

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.apple-silicon
    outputs.overlays.vscode-extensions
  ];

  hardware.asahi.useExperimentalGPUDriver = true;

  networking.hostName = "corvus";

  programs.zsh.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  system.stateVersion = "24.05";
}
