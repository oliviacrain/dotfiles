{ config, ... }:
{
  services.dex = {
    enable = true;
    environmentFile = config.sops.templates."dex.env".path;
    settings = {
      issuer = "https://auth.slug.gay";
      enablePasswordDB = false;
      storage = {
        type = "sqlite3";
        config.file = "/var/lib/dex/dex.db";
      };
      web = {
        http = "127.0.0.1:5556";
      };
      oauth2 = {
        skipApprovalScreen = true;
        alwaysShowLoginScreen = false;
      };
      connectors = [
        {
          type = "authproxy";
          id = "tailscale";
          name = "Tailscale ID Headers";
          config = {
            userIDHeader = "Tailscale-User";
            userHeader = "Tailscale-Login";
            staticGroups = ["default"];
          };
        }
      ];
      staticClients = [
        ({
          id = "forgejo";
          name = "Forgejo";
          secretEnv = "FORGEJO_OAUTH_SECRET";
          redirectURIs = [
            "https://git.slug.gay/user/oauth2/dex/callback"
          ];
        })
      ];
    };
  };
  systemd.services.dex.serviceConfig.StateDirectory = "dex";
}
