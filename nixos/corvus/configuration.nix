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
    ../common
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.apple-silicon
    outputs.overlays.vscode-extensions
  ];

  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  hardware.asahi.useExperimentalGPUDriver = true;

  networking = {
    hostName = "corvus";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd.enable = true;
    wireless.iwd.settings.General.EnableNetworkConfiguration = true;
  };

  programs.zsh.enable = true;
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };
  programs.ssh.startAgent = true;
  programs.ssh.enableAskPassword = true;

  sound.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = false;
  };

  environment.systemPackages = [
    pkgs.firefox
    pkgs.kdePackages.neochat
    pkgs.kdePackages.tokodon
  ];

  fonts.packages = [ pkgs.berkeley-mono ];

  system.stateVersion = "24.05";
}
