{
  lib,
  pkgs,
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
  inherit (builtins) attrValues;
in
{
  options.olivia.nix.enable = mkEnableOption "common nix/nixpkgs options";

  config = mkIf config.olivia.nix.enable {
    nix = {
      package = pkgs.lixPackageSets.stable.lix;
      settings = {
        experimental-features = mkDefault [
          "nix-command"
          "flakes"
        ];
        trusted-users = [ "olivia" ];
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
      overlays = mkAfter (attrValues {
        inherit (outputs.overlays)
          additions
          modifications
          ;
      });
      config = {
        allowUnfree = mkDefault true;
      };
    };
  };
}
