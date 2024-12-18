{
  inputs,
  config,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/digital-ocean-image.nix"
    inputs.sops-nix.nixosModules.sops
  ];

  networking.hostName = "strigidae";
  system.stateVersion = "25.05";

  networking.firewall.allowedTCPPorts = [443];

  services.kanidm = {
    enableServer = true;
    serverSettings = let
      certDir = config.security.acme.certs."auth.slug.gay".directory;
    in {
      bindaddress = "159.65.243.4:443";
      domain = "auth.slug.gay";
      origin = "https://auth.slug.gay";
      tls_chain = "${certDir}/fullchain.pem";
      tls_key = "${certDir}/key.pem";
    };
  };

  users.users.kanidm.extraGroups = ["acme"];
  systemd.services.kanidm = {
    serviceConfig.AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
    requires = ["acme-finished-auth.slug.gay.target"];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "mail+acme" + "@slug.gay";
    certs."auth.slug.gay" = {
      domain = "auth.slug.gay";
      dnsProvider = "porkbun";
      environmentFile = config.sops.templates."acme.env".path;
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;
    secrets = {
      porkbunApiKey = {};
      porkbunSecretApiKey = {};
    };
    templates."acme.env" = {
      content = ''
        PORKBUN_API_KEY=${config.sops.placeholder.porkbunApiKey}
        PORKBUN_SECRET_API_KEY=${config.sops.placeholder.porkbunSecretApiKey}
      '';
    };
  };
}
