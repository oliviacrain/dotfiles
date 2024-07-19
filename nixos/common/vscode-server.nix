{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  imports = [inputs.vscode-server.nixosModules.default];

  options.olivia.vscode-server.enable = mkEnableOption "vscode-server";

  config = mkIf config.olivia.vscode-server.enable {
    services.vscode-server.enable = mkDefault true;
  };
}
