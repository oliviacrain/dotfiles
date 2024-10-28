{
  lib,
  config,
  inputs,
  outputs,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkAfter
    ;
in {
  options.olivia.nix.enable = mkEnableOption "common nix/nixpkgs options";

  config = mkIf config.olivia.nix.enable {
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
      buildMachines = mkIf (config.networking.hostName != "apteryx") [
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
      distributedBuilds = mkDefault true;

      gc = {
        automatic = true;
        persistent = true;
        dates = "weekly";
      };
    };
    nixpkgs = {
      overlays = mkAfter [
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.vscode-extensions
        outputs.overlays.lix-module
      ];
      config = {
        allowUnfree = mkDefault true;
        permittedInsecurePackages = [
          "litestream-0.3.13"
        ];
      };
    };
  };
}
