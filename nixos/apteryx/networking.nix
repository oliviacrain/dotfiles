{
  pkgs,
  config,
  ...
}:
let
  inherit (builtins) toString;
in
{
  services.tailscale = {
    permitCertUid = config.services.caddy.user;
    authKeyFile = config.sops.secrets."tailscale/auth_key".path;
  };

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = config.sops.templates."caddy.env".path;
    BindPaths = [
      config.services.tailscaleAuth.socketPath
      config.services.hedgedoc.settings.path
    ];
  };

  services.tailscaleAuth.enable = true;
  systemd.services.tailscale-nginx-auth.serviceConfig.BindPaths = [
    "/var/run/tailscale/tailscaled.sock"
    "/run/tailscale/tailscaled.sock"
  ];
  users.users.${config.services.caddy.user}.extraGroups = [
    config.services.tailscaleAuth.group
    "hedgedoc"
  ];

  sops = {
    secrets."caddy/porkbun_api" = {
      mode = "0440";
      owner = config.services.caddy.user;
      group = config.services.caddy.group;
    };
    secrets."caddy/porkbun_secret" = {
      mode = "0440";
      owner = config.services.caddy.user;
      group = config.services.caddy.group;
    };
    templates."caddy.env" = {
      content = ''
        PORKBUN_API=${config.sops.placeholder."caddy/porkbun_api"}
        PORKBUN_SECRET=${config.sops.placeholder."caddy/porkbun_secret"}
      '';
      owner = config.services.caddy.user;
      group = config.services.caddy.group;
      mode = "0440";
    };
    secrets."tailscale/auth_key" = {
      reloadUnits = [ "tailscale-autoconnect.service" ];
    };
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy-augmented;
    configFile = pkgs.writeText "Caddyfile" ''
      (tailscale_service) {
        bind 100.95.200.106 fd7a:115c:a1e0::891f:c86a
        @blocked not client_ip 100.64.0.0/10 fd7a:115c:a1e0::/96 192.168.0.0/16
        tls {
          dns porkbun {
            api_key {env.PORKBUN_API}
            api_secret_key {env.PORKBUN_SECRET}
          }
          resolvers 9.9.9.9 1.1.1.1 8.8.8.8
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

      # Miniflux
      https://rss.slug.gay {
        import tailscale_service
        reverse_proxy localhost:6613
      }

      # Hedgedoc
      https://notes.slug.gay {
        import tailscale_service
        reverse_proxy unix/${config.services.hedgedoc.settings.path}
      }

      # Atuin Sync
      https://atuin.slug.gay {
        import tailscale_service
        reverse_proxy localhost:${toString config.services.atuin.port}
      }
    '';
  };
}
