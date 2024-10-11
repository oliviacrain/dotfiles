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
  # https://github.com/NixOS/nixpkgs/issues/344167
  boot.kernelPackages = pkgs.linuxPackages_6_10;
  programs.steam.enable = true;

  system.stateVersion = "23.11";
}
