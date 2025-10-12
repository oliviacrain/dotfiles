{pkgs, ...}: let
  inherit (pkgs) callPackage;
in {
  caddy-augmented = pkgs.caddy.withPlugins {
    plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
    hash = "sha256-PUHu+KPywdJMuPLHPtQhUaw3Cv1pED5XQ1MOzlT/6h4=";
  };

  witchhazel = callPackage ./witchhazel.nix {};
  berkeley-mono = callPackage ./berkeley-mono.nix {};
  to-the-sky-background = callPackage ./to-the-sky-background.nix {};
}
