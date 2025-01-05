{
  pkgs,
  lib,
  ...
}: {
  users.users.olivia.extraGroups = ["tss"];
  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
    pkcs11.enable = true;
    tctiEnvironment = {
      enable = true;
      interface = "tabrmd";
    };
  };
  environment.systemPackages = [pkgs.tpm2-tools];

  home-manager.users.olivia.home.file.".ssh/config".text = ''
    PKCS11Provider ${lib.getLib pkgs.tpm2-pkcs11}/lib/libtpm2_pkcs11.so.0.0.0
  '';
}
