{pkgs, config, ...}: {
  services.mealie = {
    enable = true;
    settings = {
      BASE_URL = "https://recipes.slug.gay/";
      OIDC_PROVIDER_NAME = "SlugID";
      OIDC_USER_GROUP = "slug_users@auth.slug.gay";
      OIDC_ADMIN_GROUP = "slug_admins@auth.slug.gay";
      OIDC_USER_CLAIM = "preferred_username";
      OIDC_AUTH_ENABLED = true;
      OIDC_CONFIGURATION_URL = "https://auth.slug.gay/oauth2/openid/mealie/.well-known/openid-configuration";
      OIDC_CLIENT_ID = "mealie";
      OIDC_SIGNUP_ENABLED = true;
    };
    credentialsFile = config.sops.templates."mealie.env".path;
  };

  sops = {
    secrets."mealie/oidc_client_secret" = {};
    templates."mealie.env".content = ''
        OIDC_CLIENT_SECRET=${config.sops.placeholder."mealie/oidc_client_secret"}
    '';
  };

}
