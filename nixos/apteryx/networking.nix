{
  lib,
  pkgs,
  config,
  ...
}:
{
  networking = {
    hostName = "apteryx";
    networkmanager.enable = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  services.tailscale = {
    package = pkgs.unstable.tailscale;
    permitCertUid = config.services.caddy.user;
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy-with-porkbun;
    configFile = pkgs.writeText "Caddyfile" ''
      https://apteryx.tail15aab.ts.net:443 {
        redir /requests/ /requests
        redir /requests https://apteryx.tail15aab.ts.net:5066
        redir /mealie/ /mealie
        redir /mealie https://apteryx.tail15aab.ts.net:8989
        redir /jellyfin /jellyfin/
        reverse_proxy /jellyfin/* http://localhost:8096
      }
      # Mealie doesn't let us serve from a subpath :(
      https://apteryx.tail15aab.ts.net:8989 {
        reverse_proxy http://localhost:9000
      }
      # Jellyseerr doesn't let us serve from a subpath :(
      https://apteryx.tail15aab.ts.net:5066 {
        reverse_proxy http://localhost:5055
      }

    '';
  };
}
