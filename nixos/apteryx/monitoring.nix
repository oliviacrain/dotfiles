{config, ...}: {
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
        name = config.networking.hostName;
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
