{inputs, ...}: {
  services.actual = {
    enable = true;
    settings = {
      hostname = "127.0.0.1";
      port = 60567;
    };
  };
}
