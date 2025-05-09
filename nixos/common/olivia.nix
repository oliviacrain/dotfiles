{pkgs, ...}: let
  username = "olivia";
in {
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "dialout"
    ];
    home = "/home/${username}";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIAcHy4OLWLYz3mrLJRPtJjSbuB0ovD2rKDrKzxjQmgSwAAAABHNzaDo= olivia@olivia.dev"
    ];
  };

  services.openssh.settings.AllowUsers = [username];

  programs.ssh.startAgent = true;
  programs.ssh.enableAskPassword = true;

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      dua
      slumber
      ;
  };
}
