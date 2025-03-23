{pkgs, ...}: let
  inherit (pkgs) callPackage;
in {
  caddy-with-porkbun = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.2.1"];
    hash = "sha256-X8QbRc2ahW1B5niV8i3sbfpe1OPYoaQ4LwbfeaWvfjg=";
  };

  witchhazel = callPackage ./witchhazel.nix {};
  berkeley-mono = callPackage ./berkeley-mono.nix {};
  to-the-sky-background = callPackage ./to-the-sky-background.nix {};
}
