{...}: {
  services.minecraft-server = mkDefault {
    enable = true;
    declarative = true;
    eula = true;
    dataDir = "/srv/minecraft";
    serverProperties = {
      motd = "Slug Minecraft!";
    };
  };
}
