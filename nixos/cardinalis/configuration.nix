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

  networking.hostName = "cardinalis";
  olivia = {
    enable = true;
    nvidia.enable = true;
  };

  programs.steam.enable = true;

  system.stateVersion = "23.11";
}
