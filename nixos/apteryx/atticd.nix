{
  inputs,
  config,
  ...
}: {
  imports = [inputs.attic.nixosModules.atticd];

  sops.secrets."atticd/token_hs256" = {};
  sops.secrets."atticd/aws_access_key" = {};
  sops.secrets."atticd/aws_secret_access_key" = {};
  sops.templates."atticd.env" = {
    content = ''
      ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="${config.sops.placeholder."atticd/token_hs256"}"
      AWS_ACCESS_KEY_ID="${config.sops.placeholder."atticd/aws_access_key"}"
      AWS_SECRET_ACCESS_KEY="${config.sops.placeholder."atticd/aws_secret_access_key"}"
    '';
  };

  services.atticd = {
    enable = true;
    credentialsFile = config.sops.templates."atticd.env".path;
    settings = {
      listen = "[::1]:8254";
      api-endpoint = "https://attic.slug.gay/";
      compression.type = "zstd";
      storage = {
        type = "s3";
        region = "us-east-2";
        bucket = "slug-infra-attic-bucket";
      };
      # Defaults from https://docs.attic.rs/admin-guide/chunking.html
      # at commit e127acbf9a71ebc0c26bc8e28346822e0a6e16ba
      chunking = {
        nar-size-threshold = 131072;
        min-size = 65536;
        avg-size = 131072;
        max-size = 262144;
      };
    };
  };
}
