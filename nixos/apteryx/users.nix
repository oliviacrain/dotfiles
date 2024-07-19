{pkgs, ...}: {
  users.users.slug = {
    isNormalUser = true;
    home = "/home/slug";
    packages = [pkgs.firefox];
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHUsGHZq0RCKL18r0HLLD+yFV8WdhEUvKi/gBPYFG8J9 root@corvus"
    ];
  };

  nix.settings.trusted-users = ["nixremote"];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      AllowUsers = [
        "margie"
        "nixremote"
      ];
    };
    openFirewall = true;
  };
}
