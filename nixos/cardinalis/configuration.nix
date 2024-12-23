{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  networking.hostName = "cardinalis";
  olivia.enable = true;

  services.openssh.enable = true;
  systemd.network.wait-online.enable = false;
  # https://github.com/NixOS/nixpkgs/issues/344167
  boot.kernelPackages = pkgs.linuxPackages_6_10;
  programs.steam.enable = true;

  hardware.nvidia = {
    modesetting.enable = mkDefault true;
    powerManagement.enable = mkDefault false;
    powerManagement.finegrained = mkDefault false;
    open = mkDefault false;
    nvidiaSettings = mkDefault true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  system.stateVersion = "23.11";
}
