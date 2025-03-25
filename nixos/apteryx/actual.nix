{config, ...}: {
  services.actual = {
    enable = true;
    settings = {
      hostname = "127.0.0.1";
      port = 60567;
      openId = {
        issuer = "https://auth.slug.gay/oauth2/openid/actual/.well-known/openid-configuration";
        client_id = "actual";
        server_hostname = "https://budget.slug.gay/";
        authMethod = "openid";
      };
    };
  };

  systemd.services.actual.serviceConfig.EnvironmentFile = config.sops.templates."actual.env".path;

  sops = {
    secrets."actual/oidc_client_secret" = {};
    templates."actual.env" = {
      content = ''
        ACTUAL_OPENID_CLIENT_SECRET=${config.sops.placeholder."actual/oidc_client_secret"}
        ACTUAL_OPENID_ENFORCE=true
      '';
    };
  };
}
