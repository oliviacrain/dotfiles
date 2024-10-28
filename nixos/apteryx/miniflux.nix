{config, ...}: {
  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "localhost:6613";
      BASE_URL = "https://rss.slug.gay/";
    };
    createDatabaseLocally = true;
    adminCredentialsFile = config.sops.templates."miniflux-admin-seed.env".path;
  };
  sops = {
    secrets."miniflux/admin_password_seed" = {};
    templates."miniflux-admin-seed.env" = {
      content = ''
        ADMIN_USERNAME=admin
        ADMIN_PASSWORD=${config.sops.placeholder."miniflux/admin_password_seed"}
      '';
    };
  };
}
