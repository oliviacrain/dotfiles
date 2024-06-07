{ inputs, config, ... }:
{
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../secrets/apteryx.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key"];
    secrets."caddy/porkbun_api" = {
      mode = "0440";
      owner = config.services.caddy.user;
      group = config.services.caddy.group;
    };
    secrets."caddy/porkbun_secret" = {
      mode = "0440";
      owner = config.services.caddy.user;
      group = config.services.caddy.group;
    };
  };

}
