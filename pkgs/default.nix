# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs, ...}: let
  inherit (pkgs) callPackage;
in {
  caddy-with-porkbun = callPackage ./caddy-with-plugins.nix {
    vendorHash = "sha256-tR9DQYmI7dGvj0W0Dsze0/BaLjG84hecm0TPiCVSY2Y=";
    externalPlugins = [
      {
        name = "porkbun";
        repo = "github.com/caddy-dns/porkbun";
        version = "v0.1.4";
      }
    ];
  };

  witchhazel = callPackage ./witchhazel.nix {};
  berkeley-mono = callPackage ./berkeley-mono.nix {};
  to-the-sky-background = callPackage ./to-the-sky-background.nix {};
  asahi-firmware-corvus = callPackage ./asahi-firmware-corvus.nix {};
}
