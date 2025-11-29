{pkgs, ...}: let
  inherit (pkgs) callPackage;
in {
  caddy-augmented = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
    hash = "sha256-aVSE8y9Bt+XS7+M27Ua+ewxRIcX51PuFu4+mqKbWFwo=";
  };

  witchhazel = callPackage ./witchhazel.nix {};
  berkeley-mono = callPackage ./berkeley-mono.nix {};
  to-the-sky-background = callPackage ./to-the-sky-background.nix {};
}
