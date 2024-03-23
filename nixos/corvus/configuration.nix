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
  ];

  networking.hostName = "corvus";
  olivia = {
    enable = true;
    asahi.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  system.stateVersion = "24.05";
}
