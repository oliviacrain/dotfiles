{ pkgs, ... }:
{
  services.dex = {
    enable = false;
    environmentFile = null;
    settings = {
      issuer = "https://auth.slug.gay";
      enablePasswordDB = false;
      storage = {
        type = "sqlite3";
        config.file = "/var/lib/dex/dex.db";
      };
      web = {
        http = "http://127.0.0.1:5556";
      };
      connectors = [
        {
          type = "authproxy";
          id = "tailscale";
          name = "Tailscale ID Headers";
          config = {
            userHeader = "Tailscale-User-Login";
            staticGroups = ["default"];
          };
        }
      ];
    };
  };
  config.systemd.services.dex.serviceConfig.StateDirectory = "dex";
}
