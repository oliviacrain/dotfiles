{
  lib,
  config,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkAfter
    ;
in
{

  imports = [ inputs.lix-module.nixosModules.default ];

  options.olivia.nix.enable = mkEnableOption "common nix/nixpkgs options";
  options.olivia.nix.useApteryxRemote = mkEnableOption "use of apteryx as a remote builder";

  config = mkIf config.olivia.nix.enable {
    nix = {
      settings.experimental-features = mkDefault [
        "nix-command"
        "flakes"
      ];
      registry.nixpkgs.flake = mkDefault inputs.nixpkgs;
      buildMachines = mkIf config.olivia.nix.useApteryxRemote [
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
      distributedBuilds = mkIf config.olivia.nix.useApteryxRemote true;

      gc = {
        automatic = true;
        persistent = true;
        dates = "weekly";
      };
    };

    nix.settings.extra-substituters = [ "https://cache.lix.systems" ];

    nix.settings.trusted-public-keys = [
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];

    nixpkgs = {
      overlays = mkAfter [
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.vscode-extensions
      ];
      config.allowUnfree = mkDefault true;
    };
  };
}
