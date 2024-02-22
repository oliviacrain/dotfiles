{ pkgs, ... }:
{
  users.users.olivia = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    home = "/home/olivia";
    packages = with pkgs; [
      firefox
      kate
      git
    ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAcHy4OLWLYz3mrLJRPtJjSbuB0ovD2rKDrKzxjQmgSwAAAABHNzaDo= olivia@olivia.dev"
    ];
  };

  users.users.slug = {
    isNormalUser = true;
    home = "/home/slug";
    packages = with pkgs; [
      firefox
      kate
    ];
  };

  users.users.margie = {
    isNormalUser = true;
    home = "/home/margie";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEbSgwkKC4XJWX1OgB9uyeeMookTrOuhe3cJuExtgUjx eddsa-key-20240214"
    ];
  };

  users.users.nixremote = {
    isNormalUser = true;
    home = "/home/nixremote";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgetZN4IN8ngswhuBm1jWUCP0k0TbSg9BMGvqI6o2+i root@corvus"
    ];
  };

  nix.settings.trusted-users = [ "nixremote" ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [
        "olivia"
        "margie"
        "nixremote"
      ];
    };
    openFirewall = true;
  };
}
