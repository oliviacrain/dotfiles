{
  lib,
  config,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
in
{
  options.olivia.minecraft.enable = mkEnableOption "a minecraft server";

  config = mkIf config.olivia.minecraft.enable {
    services.minecraft-server = mkDefault {
      enable = true;
      declarative = true;
      eula = true;
      dataDir = "/srv/minecraft";
      serverProperties = {
        motd = "Slug Minecraft!";
      };
    };
  };
}
