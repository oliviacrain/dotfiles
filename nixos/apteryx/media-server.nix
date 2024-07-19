{pkgs, ...}: {
  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      amdgpu_top
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
      jellyseerr
      ;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.jellyseerr.enable = true;
}
