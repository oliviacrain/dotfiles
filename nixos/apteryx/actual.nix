{
  inputs,
  outputs,
  ...
}: {
  imports = [ "${inputs.nixpkgs-actual}/nixos/modules/services/web-apps/actual.nix" ];
  nixpkgs.overlays = [ outputs.overlays.actual-budget ];

  services.actual = {
    enable = true;
    settings = {
      hostname = "127.0.0.1";
      port = 80567;
    };
  };
}
