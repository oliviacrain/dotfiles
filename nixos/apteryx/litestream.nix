{config, ...}: {
  services.litestream = {
    enable = true;
    environmentFile = config.sops.templates."litestream.env".path;
    settings = {
      dbs = [
      ];
    };
  };

  sops.secrets."litestream/aws_access_key" = {};
  sops.secrets."litestream/aws_secret_access_key" = {};
  sops.secrets."litestream/s3_bucket_url" = {};
  sops.secrets."litestream/s3_bucket_region" = {};
  sops.templates."litestream.env" = {
    content = ''
      LITESTREAM_ACCESS_KEY_ID=${config.sops.placeholder."litestream/aws_access_key"}
      LITESTREAM_SECRET_ACCESS_KEY=${config.sops.placeholder."litestream/aws_secret_access_key"}
      S3_BUCKET_URL=${config.sops.placeholder."litestream/s3_bucket_url"}
      S3_BUCKET_REGION=${config.sops.placeholder."litestream/s3_bucket_region"}
    '';
    owner = "litestream";
    group = "litestream";
    mode = "0400";
  };
}
