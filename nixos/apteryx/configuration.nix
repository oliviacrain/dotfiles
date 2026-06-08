{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common
    ./caddy.nix
    ./media-server.nix
    ./mealie.nix
    ./forgejo.nix
    ./monitoring.nix
    ./miniflux.nix
    ./hedgedoc.nix
    ./bentopdf.nix
  ];

  networking.hostName = "apteryx";
  olivia = {
    enable = true;
    colmena.enable = true;
    desktop.enable = false;
  };

  system.stateVersion = "23.11";
}
