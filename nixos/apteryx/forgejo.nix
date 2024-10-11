{
  config,
  lib,
  ...
}: {
  services.forgejo = {
    enable = true;
    secrets = {
      security = {
        SECRET_KEY = lib.mkForce config.sops.secrets."forgejo/secret_key".path;
        INTERNAL_TOKEN = lib.mkForce config.sops.secrets."forgejo/internal_token".path;
      };
    };
    database.type = "sqlite3";
    lfs.enable = false;
    settings = {
      server = {
        PROTOCOL = "http+unix";
        DOMAIN = "git.slug.gay";
        ROOT_URL = "https://git.slug.gay/";
      };
      oauth2_client = {
        OPENID_CONNECT_SCOPES = "email profile";
        ENABLE_AUTO_REGISTRATION = true;
      };
      oauth2.ENABLED = false;
      service = {
        REQUIRE_SIGNIN_VIEW = true;
        DISABLE_REGISTRATION = false;
      };
      repository.DISABLE_HTTP_GIT = true;
    };
  };
  services.openssh.settings.AllowUsers = [config.services.forgejo.user];
  sops = {
    secrets."forgejo/secret_key" = {
      mode = "0400";
      owner = config.services.forgejo.user;
      group = config.services.forgejo.group;
    };
    secrets."forgejo/internal_token" = {
      mode = "0400";
      owner = config.services.forgejo.user;
      group = config.services.forgejo.group;
    };
  };
}
