{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  networking.hostName = "buteo";

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFC/5xC4mZ/7SIKKVsXhaYFMbf94oefRpMKOxTTzKsNx olivia@corvus"
  ];

  users.users.olivia = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    home = "/home/olivia";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAcHy4OLWLYz3mrLJRPtJjSbuB0ovD2rKDrKzxjQmgSwAAAABHNzaDo= olivia@olivia.dev"
    ];
  };

  nix = {
    settings = {
      experimental-features = mkDefault [
        "nix-command"
        "flakes"
      ];
      trusted-users = ["olivia"];
      extra-substituters = ["https://cache.lix.systems"];
      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
    };
    extraOptions = ''
      builders-use-substitutes = true
    '';
    registry.nixpkgs.flake = mkDefault inputs.nixpkgs;
    buildMachines = [
      {
        hostName = "apteryx";
        sshUser = "nixremote";
        system = "x86_64-linux";
        maxJobs = 8;
        supportedFeatures = [
          "big-parallel"
          "kvm"
        ];
      }
    ];
    distributedBuilds = true;

    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
    };
  };

  services.caddy = {
    enable = true;
  };
  services.gotosocial = {
    enable = true;
  };

  system.stateVersion = "24.05";
}
