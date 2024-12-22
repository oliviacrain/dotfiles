{...}: {
  services.atuin = {
    enable = true;
    host = "127.0.0.1";
    port = 8321;
    openRegistration = false;
    database.createLocally = true;
  };
}
