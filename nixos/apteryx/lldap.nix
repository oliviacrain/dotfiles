{ config, ... }:
{
  services.lldap = {
    enable = true;
    settings = {
      ldap_base_dn = "dc=slug,dc=gay";
      ldap_user_dn = "admin";
      ldap_user_email = "admin@slug.gay";
      ldap_host = "localhost";
      http_host = "localhost";
      http_url = "https://lldap.slug.gay";
    };
  };

  systemd.services.lldap.serviceConfig = {
    LoadCredential = [
      "jwt_secret:${config.sops.secrets."lldap/jwt_secret".path}"
      "admin_user_pass:${config.sops.secrets."lldap/admin_user_pass".path}"
    ];
    Environment = [
      "LLDAP_JWT_SECRET_FILE=%d/jwt_secret"
      "LLDAP_LDAP_USER_PASS_FILE=%d/admin_user_pass"
    ];
  };

  sops.secrets."lldap/jwt_secret" = {};
  sops.secrets."lldap/admin_user_pass" = {};
}
