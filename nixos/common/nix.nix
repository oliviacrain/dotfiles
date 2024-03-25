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
  options.olivia.nix.enable = mkEnableOption "common nix/nixpkgs options";

  config = mkIf config.olivia.nix.enable {
    nix = {
      settings.experimental-features = mkDefault [
        "nix-command"
        "flakes"
      ];
      registry.nixpkgs.flake = mkDefault inputs.nixpkgs;
    };

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
