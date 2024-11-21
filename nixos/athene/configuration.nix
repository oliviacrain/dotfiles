{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./hardware-configuration.nix
    ../common

    ./secure-boot.nix
    #./tpm-ssh.nix
    ./gaming.nix
  ];

  olivia.enable = true;
  networking.hostName = "athene";
  home-manager.users.olivia.home.packages = [pkgs.signal-desktop pkgs.spotify];

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;
  services.fwupd.enable = true;

  programs.virt-manager.enable = true;

  system.stateVersion = "24.11";
}
