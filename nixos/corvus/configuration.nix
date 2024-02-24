{
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.apple-silicon
    ];
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware.asahi = {
    useExperimentalGPUDriver = true;
    addEdgeKernelConfig = true;
  };

  sound.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  environment.systemPackages = with pkgs; [ vim ];

  networking.hostName = "corvus";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";
  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ 22 ];
  };
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "23.11";
}
