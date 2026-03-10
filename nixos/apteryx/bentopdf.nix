{
  pkgs,
  config,
  ...
}:
let
  domain = "pdf.slug.gay";
in
{
  services.bentopdf = {
    inherit domain;
    enable = true;
    caddy = {
      enable = true;
      virtualHost = {
        hostName = "https://${domain}";
        extraConfig = ''
          import tailscale_service
        '';
      };
    };
  };
}
