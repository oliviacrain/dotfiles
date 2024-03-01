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
    ./desktop.nix
    "${inputs.nixpkgs-mealie}/nixos/modules/services/web-apps/mealie.nix"
  ];

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.unstable-packages
    outputs.overlays.litchipi-packages
  ];

  environment.systemPackages = with pkgs; [ vim ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.vscode-server.enable = true;

  services.mealie = {
    enable = true;
    package = pkgs.litchipi.mealie;
    settings = {
      BASE_URL = "https://apteryx.tail15aab.ts.net:8999/";
    };
  };

  system.stateVersion = "23.11";
}
