{config, ...}: {
  services.miniflux = {
    enable = true;
    config = {
      CREATE_ADMIN = 0;
      LISTEN_ADDR = "localhost:6613";
      BASE_URL = "https://rss.slug.gay/";
      OAUTH2_OIDC_PROVIDER_NAME = "SlugID";
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_CLIENT_ID = "miniflux";
      # OAUTH2_CLIENT_SECRET is set as an env var
      OAUTH2_REDIRECT_URL = "https://rss.slug.gay/oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.slug.gay/oauth2/openid/oidc";
      OAUTH2_USER_CREATION = 1;
    };
    createDatabaseLocally = true;
  };

  systemd.services.miniflux.serviceConfig.EnvironmentFile = config.sops.templates."miniflux.env".path;

  sops = {
    secrets."miniflux/oidc_client_secret" = {};
    templates."miniflux.env" = {
      content = ''
        OAUTH2_CLIENT_SECRET=${config.sops.placeholder."miniflux/oidc_client_secret"}
      '';
    };
  };
}
