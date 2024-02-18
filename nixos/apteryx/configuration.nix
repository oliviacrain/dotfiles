{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    "${inputs.nixpkgs-mealie}/nixos/modules/services/web-apps/mealie.nix"
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
      outputs.overlays.litchipi-packages
    ];
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "apteryx";
  networking.networkmanager.enable = true;
  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

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
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    home = "/home/olivia";
    packages = with pkgs; [
      firefox
      kate
      git
    ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAcHy4OLWLYz3mrLJRPtJjSbuB0ovD2rKDrKzxjQmgSwAAAABHNzaDo= olivia@olivia.dev"
    ];
  };

  users.users.slug = {
    isNormalUser = true;
    home = "/home/slug";
    packages = with pkgs; [
      firefox
      kate
    ];
  };

  users.users.margie = {
    isNormalUser = true;
    home = "/home/margie";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbSgwkKC4XJWX1OgB9uyeeMookTrOuhe3cJuExtgUjx eddsa-key-20240214"
    ];
  };

  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [
        "olivia"
        "margie"
      ];
    };
    openFirewall = true;
  };

  services.vscode-server.enable = true;
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
    permitCertUid = config.services.caddy.user;
  };
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ 22 ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.jellyseerr.enable = true;

  services.caddy = {
    enable = true;
    package = pkgs.caddy-with-porkbun;
    configFile = pkgs.writeText "Caddyfile" ''
      https://apteryx.tail15aab.ts.net:443 {
        redir /requests/ /requests
        redir /requests https://apteryx.tail15aab.ts.net:5066
        redir /mealie/ /mealie
        redir /mealie https://apteryx.tail15aab.ts.net:8989
        redir /jellyfin /jellyfin/
        reverse_proxy /jellyfin/* http://localhost:8096
      }
      https://apteryx.tail15aab.ts.net:8989 {
        reverse_proxy http://localhost:9000
      }
      https://apteryx.tail15aab.ts.net:5066 {
        reverse_proxy http://localhost:5055
      }

    '';
  };

  services.mealie = {
    enable = true;
    package = pkgs.litchipi.mealie;
    settings = {
      BASE_URL = https://apteryx.tail15aab.ts.net:8999/;
    };
  };

  system.stateVersion = "23.11";
}
