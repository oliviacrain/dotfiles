{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
      inherit (inputs.nixpkgs-patched-clamav.legacyPackages.${prev.system})
        clamav;

      jellyseerr = prev.jellyseerr.overrideAttrs(oldAttrs: {
        patches = ( oldAttrs.patches or [] ) ++ [
          (
            prev.fetchpatch {
              url = "https://github.com/Fallenbagel/jellyseerr/commit/268c7df28eea8b911d6a53297f5ce296983067ce.patch";
              hash = prev.lib.fakeHash;
            }
          )
        ];
      });

      # https://github.com/NixOS/nixpkgs/issues/326296
      mealie = prev.mealie.override { python3Packages = final.python311Packages; };
    };

  apple-silicon = inputs.apple-silicon.overlays.apple-silicon-overlay;
  widevine = inputs.widevine.overlays.default;
  vscode-extensions = inputs.vscode-extensions.overlays.default;
}
