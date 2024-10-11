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
  ];

  networking.hostName = "apteryx";
  olivia = {
    enable = true;
    minecraft.enable = true;
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';

  environment.systemPackages = [pkgs.vlc];

  system.stateVersion = "23.11";
}
