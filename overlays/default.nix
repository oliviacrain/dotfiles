{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
      clamav = prev.clamav.overrideAttrs(oldAttrs: {
          checkInputs = (oldAttrs.checkInputs or []) ++ [
            final.python3.pkgs.pytest
          ];
      });

      jellyseerr = prev.jellyseerr.overrideAttrs(oldAttrs: {
        patches = ( oldAttrs.patches or [] ) ++ [
          (
            prev.fetchpatch {
              url = "https://github.com/Fallenbagel/jellyseerr/commit/268c7df28eea8b911d6a53297f5ce296983067ce.patch";
              hash = "sha256-3MUdF9KgYcP/szNF4H4OiaHvm2D5EUa/y5yFsvh/Zpw=";
            }
          )
        ];
      });

      python311 = prev.python311.override {
        packageOverrides = pfinal: pprev: {
          extruct = pprev.extruct.overridePythonAttrs (oldAttrs: {
            version = "0.17.0";
            src = final.fetchFromGitHub {
              owner = "scrapinghub";
              repo = "extruct";
              rev = "refs/tags/v0.17.0";
              hash = "sha256-CfhIqbhrZkJ232grhHxrmj4H1/Bq33ZXe8kovSOWSK0=";
            };
          });
        };
      };

      # https://github.com/NixOS/nixpkgs/issues/326296
      mealie = prev.mealie.override { python3Packages = final.python311Packages; };
    };

  apple-silicon = inputs.apple-silicon.overlays.apple-silicon-overlay;
  widevine = inputs.widevine.overlays.default;
  vscode-extensions = inputs.vscode-extensions.overlays.default;
}
