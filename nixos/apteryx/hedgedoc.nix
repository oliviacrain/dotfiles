{config, ...}: {
  services.hedgedoc = {
    enable = true;
    settings = {
      domain = "notes.slug.gay";
      path = "/run/hedgedoc/hedgedoc.sock";
      protocolUseSSL = true;
      allowAnonymous = false;
      email = false;
      allowGravatar = false;
    };
    environmentFile = config.sops.templates."hedgedoc.env".path;
  };

  sops = {
    secrets."hedgedoc/oidc_client_secret" = {};
    templates."hedgedoc.env".content = ''
      CMD_OAUTH2_USER_PROFILE_URL=https://auth.slug.gay/oauth2/openid/hedgedoc/userinfo
      CMD_OAUTH2_USER_PROFILE_USERNAME_ATTR=preferred_username
      CMD_OAUTH2_USER_PROFILE_DISPLAY_NAME_ATTR=name
      CMD_OAUTH2_USER_PROFILE_EMAIL_ATTR=email
      CMD_OAUTH2_TOKEN_URL=https://auth.slug.gay/oauth2/token
      CMD_OAUTH2_AUTHORIZATION_URL=https://auth.slug.gay/ui/oauth2
      CMD_OAUTH2_CLIENT_ID=hedgedoc
      CMD_OAUTH2_CLIENT_SECRET=${config.sops.placeholder."hedgedoc/oidc_client_secret"}
      CMD_OAUTH2_PROVIDERNAME=SlugID
      CMD_OAUTH2_SCOPE=openid email profile
      CMD_PROTOCOL_USESSL=true
      CMD_URL_ADDPORT=false
    '';
  };
}
