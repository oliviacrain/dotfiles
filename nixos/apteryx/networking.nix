{
  lib,
  pkgs,
  config,
  ...
}: {
  services.tailscale = {
    permitCertUid = config.services.caddy.user;
    authKeyFile = config.sops.secrets."tailscale/auth_key".path;
  };

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = config.sops.templates."caddy.env".path;
    BindPaths = [config.services.tailscaleAuth.socketPath];
  };

  services.tailscaleAuth.enable = true;
  systemd.services.tailscale-nginx-auth.serviceConfig.BindPaths = [
    "/var/run/tailscale/tailscaled.sock"
    "/run/tailscale/tailscaled.sock"
  ];
  users.users.${config.services.caddy.user}.extraGroups = [config.services.tailscaleAuth.group];

  services.caddy = {
    enable = true;
    package = pkgs.caddy-with-porkbun;
    configFile = pkgs.writeText "Caddyfile" ''
      (tailscale_service) {
        bind 100.95.200.106 fd7a:115c:a1e0::891f:c86a
        @blocked not client_ip 100.64.0.0/10 fd7a:115c:a1e0::/96
        tls {
          dns porkbun {
            api_key {env.PORKBUN_API}
            api_secret_key {env.PORKBUN_SECRET}
          }
        }
        respond @blocked "bye bozo" 403
        forward_auth unix/${config.services.tailscaleAuth.socketPath} {
        	uri /auth
        	header_up Remote-Addr {remote_host}
        	header_up Remote-Port {remote_port}
        	header_up Original-URI {uri}
          header_up -X-Remote-*
          header_up -Tailscale-*
        	copy_headers {
        		Tailscale-User
        		Tailscale-Name
        		Tailscale-Login
        		Tailscale-Tailnet
        		Tailscale-Profile-Picture
        	}
        }
      }

      # Jellyfin
      https://media.slug.gay {
        import tailscale_service
        reverse_proxy localhost:8096
      }

      # Jellyseerr
      https://requests.slug.gay {
        import tailscale_service
        reverse_proxy localhost:${builtins.toString config.services.jellyseerr.port}
      }

      # Mealie
      https://recipes.slug.gay {
        import tailscale_service
        reverse_proxy localhost:${builtins.toString config.services.mealie.port}
      }

      # Forgejo
      https://git.slug.gay {
        import tailscale_service
        reverse_proxy unix/${config.services.forgejo.settings.server.HTTP_ADDR}
      }

      https://attic.slug.gay {
        import tailscale_service
        reverse_proxy localhost:8254
      }

      https://rss.slug.gay {
        import tailscale_service
        reverse_proxy localhost:6613
      }
    '';
  };
}
