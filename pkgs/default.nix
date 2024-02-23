# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, ... }:
{
  caddy-with-porkbun = pkgs.callPackage ./caddy-with-plugins.nix {
    vendorHash = "sha256-tR9DQYmI7dGvj0W0Dsze0/BaLjG84hecm0TPiCVSY2Y=";
    externalPlugins = [
      {
        name = "porkbun";
        repo = "github.com/caddy-dns/porkbun";
        version = "v0.1.4";
      }
    ];
  };

  witchhazel = pkgs.callPackage ./witchhazel.nix { };

  berkeley-mono = pkgs.callPackage ./berkeley-mono.nix { };
}
