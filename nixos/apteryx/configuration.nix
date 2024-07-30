{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common
    ./sops.nix
    ./users.nix
    ./networking.nix
    ./media-server.nix
    ./mealie.nix
    ./litestream.nix
    ./forgejo.nix
    ./monitoring.nix
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

  system.stateVersion = "23.11";
}
