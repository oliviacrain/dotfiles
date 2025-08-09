{pkgs, ...}: let
  inherit (pkgs) callPackage;
in {
  caddy-augmented = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
    hash = "sha256-YZ4Bq0hfOJpa0C2lKipEY4fqwzJbEFM7ci5ys9S3uAo=";
  };

  witchhazel = callPackage ./witchhazel.nix {};
  berkeley-mono = callPackage ./berkeley-mono.nix {};
  to-the-sky-background = callPackage ./to-the-sky-background.nix {};
}
