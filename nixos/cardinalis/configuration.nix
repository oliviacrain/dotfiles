{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.vscode-extensions
  ];

  networking.hostName = "cardinalis";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.steam.enable = true;

  services.vscode-server.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

  system.stateVersion = "23.11";
}
