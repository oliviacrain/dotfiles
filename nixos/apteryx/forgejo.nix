{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo; # LTS by default
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
        OPENID_CONNECT_SCOPES = "email profile groups";
        ENABLE_AUTO_REGISTRATION = true;
        UPDATE_AVATAR = true;
      };
      oauth2.ENABLED = false;
      service = {
        REQUIRE_SIGNIN_VIEW = true;
        DISABLE_REGISTRATION = false;
      };
      repository.DISABLE_HTTP_GIT = true;
    };
  };

  services.openssh.settings.AllowUsers = [ config.services.forgejo.user ];

  services.caddy.virtualHosts."https://git.slug.gay/".extraConfig = ''
    import tailscale_service
    reverse_proxy unix/${config.services.forgejo.settings.server.HTTP_ADDR}
  '';

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
