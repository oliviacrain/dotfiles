{
  inputs,
  config,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../secrets/apteryx.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

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
    templates."caddy.env" = {
      content = ''
        PORKBUN_API=${config.sops.placeholder."caddy/porkbun_api"}
        PORKBUN_SECRET=${config.sops.placeholder."caddy/porkbun_secret"}
      '';
      owner = config.services.caddy.user;
      group = config.services.caddy.group;
      mode = "0440";
    };

    secrets."miniflux/admin_password_seed" = {};
    templates."miniflux-admin-seed.env" = {
      content = ''
        ADMIN_USERNAME=admin
        ADMIN_PASSWORD=${config.sops.placeholder."miniflux/admin_password_seed"}
      '';
    };

    secrets."tailscale/auth_key" = {
      reloadUnits = ["tailscale-autoconnect.service"];
    };

    secrets."forgejo/secret_key" = {
      mode = "0400";
      owner = config.services.forgejo.user;
      group = config.services.forgejo.group;
    };
    secrets."forgejo/internal_token" = {
      mode = "0400";
      owner = config.services.forgejo.user;
      group = config.services.forgejo.group;
    };
  };
}
