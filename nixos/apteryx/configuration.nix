{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    amdgpu_top
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    jellyseerr
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "apteryx";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
    services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  services.printing.enable = true;
    sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.olivia = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    home = "/home/olivia";
    packages = [
      pkgs.firefox
      pkgs.kate
    ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAcHy4OLWLYz3mrLJRPtJjSbuB0ovD2rKDrKzxjQmgSwAAAABHNzaDo= olivia@olivia.dev"
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };
  services.vscode-server.enable = true;
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
    allowedTCPPorts = [22];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.jellyseerr.enable = true;

  system.stateVersion = "23.11";
}
