{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  networking.hostName = "cardinalis";
  olivia = {
    enable = true;
    nvidia.enable = true;
  };

  services.openssh.enable = true;
  systemd.network.wait-online.enable = false;
  programs.steam.enable = true;

  system.stateVersion = "23.11";
}
