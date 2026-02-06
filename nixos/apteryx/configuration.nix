{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common
    ./users.nix
    ./networking.nix
    ./media-server.nix
    ./mealie.nix
    ./forgejo.nix
    ./monitoring.nix
    ./miniflux.nix
    ./hedgedoc.nix
  ];

  networking.hostName = "apteryx";
  olivia.enable = true;
  olivia.colmena.enable = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';

  environment.systemPackages = [ pkgs.vlc ];

  system.stateVersion = "23.11";
}
