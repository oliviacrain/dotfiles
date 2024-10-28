{
  inputs,
  outputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  imports = [
    ./hardware-configuration.nix
    ../common
    ./asahi.nix
  ];

  networking.hostName = "corvus";
  olivia = {
    enable = true;
    vscode-server.enable = false;
    nix.useApteryxRemote = true;
  };

  networking.useNetworkd = mkForce false;
  networking.wireless.iwd.enable = mkForce false;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "wpa_supplicant";

  system.stateVersion = "24.05";
}
