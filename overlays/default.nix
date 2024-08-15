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
  };

  apple-silicon = inputs.apple-silicon.overlays.apple-silicon-overlay;
  widevine = inputs.widevine.overlays.default;
  vscode-extensions = inputs.vscode-extensions.overlays.default;
}
