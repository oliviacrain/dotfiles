{ pkgs, ... }:
{
  services.jellyfin.enable = true;

  services.caddy.virtualHosts."https://media.slug.gay/".extraConfig = ''
    import tailscale_service
    reverse_proxy localhost:8096
  '';

  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];

  environment.systemPackages = [ pkgs.amdgpu_top ];
}
