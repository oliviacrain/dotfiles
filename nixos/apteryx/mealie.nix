{pkgs, ...}: {
  services.mealie = {
    enable = true;
    settings = {
      BASE_URL = "https://recipes.slug.gay/";
    };
  };
  systemd.services.mealie.serviceConfig.BindPaths = "/tmp:/run/secrets";
}
