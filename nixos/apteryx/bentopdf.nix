{
  pkgs,
  config,
  ...
}: {
  services.bentopdf = {
    enable = true;
    domain = "pdf.slug.gay";
    caddy = {
      enable = true;
      virtualHost.extraConfig = ''
        import tailscale_service
      '';
    };
  };
}
