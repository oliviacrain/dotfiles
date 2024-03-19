{
  inputs,
  outputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common
    ./networking.nix
    ./users.nix
    ./media-server.nix
  ];

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.vscode-extensions
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.vscode-server.enable = true;

  services.mealie = {
    enable = true;
    settings = {
      BASE_URL = "https://apteryx.tail15aab.ts.net:8999/";
    };
  };

  system.stateVersion = "23.11";
}
