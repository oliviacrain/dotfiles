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
    ./sops.nix
  ];

  networking.hostName = "apteryx";
  olivia = {
    enable = true;
    minecraft.enable = true;
  };

  services.mealie = {
    enable = true;
    settings = {
      BASE_URL = "https://apteryx.tail15aab.ts.net:8999/";
    };
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';

  system.stateVersion = "23.11";
}
