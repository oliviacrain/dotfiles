{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    ../common
  ];

  olivia = {
    enable = true;
    desktop.enable = false;
    home-manager.enable = false;
    boot.enable = false;
    tailscale.enable = false;
  };

  networking.hostName = "buteo";

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFC/5xC4mZ/7SIKKVsXhaYFMbf94oefRpMKOxTTzKsNx olivia@corvus"
  ];

  services.caddy = {
    enable = true;
  };
  services.gotosocial = {
    enable = true;
  };

  system.stateVersion = "24.05";
}
