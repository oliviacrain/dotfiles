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
    ./dex.nix
  ];

  networking.hostName = "apteryx";
  olivia = {
    enable = true;
    minecraft.enable = true;
  };

  services.mealie = {
    enable = true;
    settings = {
      BASE_URL = "https://recipes.slug.gay/";
    };
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
  '';

  system.stateVersion = "23.11";
}
