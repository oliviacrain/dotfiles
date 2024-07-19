{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    jellyseerr = prev.jellyseerr.overrideAttrs (
      oldAttrs: let
        version = "1.9.0";
        src = prev.fetchFromGitHub {
          owner = "Fallenbagel";
          repo = "jellyseerr";
          rev = "v${version}";
          hash = "sha256-PmHVDtWESHd4ZGJfaZMzFr89R5fPb+1CiqRN1GtPg0o=";
        };
      in {
        inherit src version;
        packageJSON = "${src}/package.json";
        offlineCache = prev.fetchYarnDeps {
          yarnLock = "${src}/yarn.lock";
          hash = "sha256-ME19kHlVw0Q5oCytYQCUj4Ek0+712NkqB6eozOtF6/k=";
        };
      }
    );

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
    mealie =
      (prev.mealie.overrideAttrs (oldAttrs: {
        patches =
          (oldAttrs.patches or [])
          ++ [
            (prev.fetchpatch {
              url = "https://patch-diff.githubusercontent.com/raw/mealie-recipes/mealie/pull/3882.patch";
              hash = "sha256-/NFAxeKJ/6UJqSb/iD3ACehiTF9WF0TPB4M3kB1yYL8=";
            })
          ];
      }))
      .override
      {python3Packages = final.python311Packages;};
  };

  apple-silicon = inputs.apple-silicon.overlays.apple-silicon-overlay;
  widevine = inputs.widevine.overlays.default;
  vscode-extensions = inputs.vscode-extensions.overlays.default;
}
