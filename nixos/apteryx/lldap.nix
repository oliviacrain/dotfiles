{ config, ... }:
{
  services.lldap = {
    enable = true;
    environment = {
      LLDAP_JWT_SECRET_FILE = config.sops.secrets."lldap/jwt_secret".path;
      LLDAP_LDAP_USER_PASS_FILE = config.sops.secrets."lldap/admin_user_pass".path;
    };
    settings = {
      ldap_base_dn = "dc=slug,dc=gay";
      ldap_user_dn = "admin";
      ldap_user_email = "admin@slug.gay";
      ldap_host = "localhost";
      http_host = "localhost";
      http_url = "https://lldap.slug.gay";
    };
  };

  sops.secrets."lldap/jwt_secret" = {
    mode = "0400";
    owner = config.systemd.services.lldap.serviceConfig.User;
    group = config.systemd.services.lldap.serviceConfig.Group;
  };
  sops.secrets."lldap/admin_user_pass" = {
    mode = "0400";
    owner = config.systemd.services.lldap.serviceConfig.User;
    group = config.systemd.services.lldap.serviceConfig.Group;
  };
}
