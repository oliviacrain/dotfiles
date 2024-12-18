{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware = {
    graphics.enable = true;
    amdgpu.amdvlk.enable = true;
  };

  environment.systemPackages = [
    pkgs.steam-run
  ];
}
