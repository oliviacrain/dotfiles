{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  unstable-packages = final: _prev: {
    unstable = {
      inherit (inputs.nixpkgs-unstable.legacyPackages.${final.system}) tailscale nixfmt-rfc-style;
    };
  };

  litchipi-packages = final: _prev: {
    litchipi = {
      inherit (inputs.nixpkgs-mealie.legacyPackages.${final.system}) mealie;
    };
  };

  apple-silicon = inputs.apple-silicon.overlays.apple-silicon-overlay;
}
