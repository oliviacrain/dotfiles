{ pkgs, ... }:
{
  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];

  environment.systemPackages = with pkgs; [
    amdgpu_top
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    jellyseerr
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.jellyseerr.enable = true;
}
