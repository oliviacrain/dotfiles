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

  system.stateVersion = "24.05";
}
