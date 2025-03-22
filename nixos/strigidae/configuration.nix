{
  inputs,
  config,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/digital-ocean-image.nix"
    ../common
  ];

  olivia = {
    boot.enable = false;
    desktop.enable = false;
    home-manager.enable = false;
    locale.enable = true;
    network.enable = false;
    nix.enable = true;
    tailscale.enable = false;
  };

  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "strigidae";
  system.stateVersion = "25.05";

  networking.firewall.allowedTCPPorts = [443];

  services.kanidm = {
    enableServer = true;
    serverSettings = let
      certDir = config.security.acme.certs."auth.slug.gay".directory;
    in {
      bindaddress = "104.131.167.151:443";
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

  services.prometheus = {
    enable = true;
    exporters.node = {
      enable = true;
      enabledCollectors = ["systemd"];
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "localhost:${toString config.services.prometheus.exporters.node.port}"
            ];
          }
        ];
      }
    ];
    remoteWrite = [
      {
        url = "https://prometheus-prod-36-prod-us-west-0.grafana.net/api/prom/push";
        basic_auth = {
          username = "1710577";
          password_file = config.sops.secrets."prometheus/grafana_basicauth_pass".path;
        };
      }
    ];
  };

  sops.secrets."prometheus/grafana_basicauth_pass" = {
    owner = "prometheus";
    group = "prometheus";
    mode = "0440";
  };
}
