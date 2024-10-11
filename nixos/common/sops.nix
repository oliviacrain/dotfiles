{
  inputs,
  config,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../secrets/${config.networking.hostName}.yaml;
    age.sshKeyPaths = ["/home/olivia/corvus-host"];
    secrets."ssh/host-key" = {};
    secrets."ssh/host-cert" = {};
  };
  services.openssh = {
    enable = true;
    hostKeys = [ {
      path = config.sops.secrets."ssh/host-key".path;
      type = "ed25519";
    } ];
    extraConfig = ''
      HostCertificate ${config.sops.secrets."ssh/host-cert".path}
    '';
    knownHosts."*.olivia.dev"= {
      certAuthority = true;
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGtraxrJgr3Dzx0jwgcKz1FUjMQ8kmZ9ZiB3DA+iLRGz";
    };
  };
}
