# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs, ...}: let
  inherit (pkgs) callPackage;
in {
  caddy-with-porkbun = callPackage ./caddy-with-plugins.nix {
    vendorHash = "sha256-BPyEYT8ZsUF0mTOhc8tq5LCxacN+AlogZO6dENZ4wRc=";
    externalPlugins = [
      {
        name = "porkbun";
        repo = "github.com/caddy-dns/porkbun";
        version = "v0.1.5";
      }
    ];
  };

  witchhazel = callPackage ./witchhazel.nix {};
  berkeley-mono = callPackage ./berkeley-mono.nix {};
  to-the-sky-background = callPackage ./to-the-sky-background.nix {};
  # Vendored https://raw.githubusercontent.com/NixOS/nixpkgs/afaa4612924a1e7ba4589b30b31abcba95f37c0e/pkgs/by-name/ac/actual-server/package.nix
  actual-server = callPackage ./actual.nix {};
}
