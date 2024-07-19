{
  lib,
  config,
  inputs,
  outputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  options.olivia.home-manager.enable = mkEnableOption "home-manager";

  config = mkIf config.olivia.home-manager.enable {
    home-manager = {
      useGlobalPkgs = mkDefault true;
      useUserPackages = mkDefault true;
      users.olivia = import ../../home-manager/home.nix;
      extraSpecialArgs = {
        inherit inputs outputs;
      };
    };
  };
}
