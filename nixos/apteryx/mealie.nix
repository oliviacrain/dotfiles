{pkgs, ... }:
{
  services.mealie = {
    enable = true;
    settings = {
      BASE_URL = "https://recipes.slug.gay/";
    };
  };
}
