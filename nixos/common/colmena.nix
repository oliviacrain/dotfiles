{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  username = "colmena-deploy";
in
{
  options.olivia.colmena.enable = mkEnableOption "colmena update user";

  config = mkIf config.olivia.colmena.enable {
    users.users.${username} = {
      isSystemUser = true;
      group = username;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC87Km2/XgeYLt9C164Bo6eCRS5iPaI4hCRLPGo9Nw3b colmena deploy"
      ];
    };
    users.groups.${username} = { };

    security.sudo = {
      extraRules = [
        {
          users = [ username ];
          commands = [
            {
              command = "/run/current-system/sw/bin/nix-store --no-gc-warning --realise /nix/store/*";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/nix-env --profile /nix/var/nix/profiles/system --set /nix/store/*";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/nix/store/*/bin/switch-to-configuration *";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };

    nix.settings.trusted-users = [ username ];
    services.openssh.settings.AllowUsers = [ username ];
  };
}
