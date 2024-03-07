{ lib, ... }:
{
  services.rustdesk-server = {
    enable = true;
    relayIP = "0.0.0.0";
  };
}
