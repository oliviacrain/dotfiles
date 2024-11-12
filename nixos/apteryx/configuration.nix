{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ./users.nix
    ./networking.nix
    ./media-server.nix
    ./mealie.nix
    ./litestream.nix
    ./forgejo.nix
    ./monitoring.nix
    ./miniflux.nix
    ./actual.nix
    ./kanidm.nix
  ];

  networking.hostName = "apteryx";
  olivia.enable = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';

  environment.systemPackages = [pkgs.vlc];

  system.stateVersion = "23.11";
}
