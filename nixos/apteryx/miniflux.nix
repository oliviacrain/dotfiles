{config, ...}: {
  services.miniflux = {
    enable = true;
    config = {
      LISTEN_ADDR = "localhost:6613";
    };
    createDatabaseLocally = true;
    adminCredentialsFile = config.sops.templates."miniflux-admin-seed.env".path;
  };
}
