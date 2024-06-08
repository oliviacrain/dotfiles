{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.tailscale.permitCertUid = config.services.caddy.user;

  systemd.services.tailscale-serve-caddy = {
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
    };
    script = ''
      ${lib.getExe pkgs.tailscale} serve --bg tcp:443 tcp://localhost:443
    '';
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates."caddy.env".path;

  services.caddy = {
    enable = true;
    package = pkgs.caddy-with-porkbun;
    configFile = pkgs.writeText "Caddyfile" ''
      (tailscale_service) {
        bind 100.95.200.106 fd7a:115c:a1e0::891f:c86a
        @blocked not client_ip 100.64.0.0/10 fd7a:115c:a1e0::/96
        tls {
          dns porkbun {
            api_key ''${env.PORKBUN_API}
            api_secret_key ''${env.PORKBUN_SECRET}
          }
        }
        respond @blocked "bye bozo" 403
      }

      # Jellyfin
      https://media.slug.gay:443 {
        import tailscale_service
        reverse_proxy localhost:8096
      }

      # Jellyseerr
      https://requests.slug.gay:443 {
        import tailscale_service
        reverse_proxy localhost:5055
      }

      # Mealie
      https://recipes.slug.gay:443 {
        import tailscale_service
        reverse_proxy localhost:9000
      }


      # legacy shit inbound

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
