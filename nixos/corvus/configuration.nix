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
    vscode-server.enable = false;
  };

  system.stateVersion = "24.05";
}
