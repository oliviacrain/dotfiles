{pkgs, ...}: {
  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];

  environment.systemPackages = [pkgs.amdgpu_top];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.jellyseerr.enable = true;
}
