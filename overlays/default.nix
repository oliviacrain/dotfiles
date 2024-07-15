{ inputs, lib, ... }:
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
              hash = lib.fakeHash;
            }
          )
        ];
      });
    };

  apple-silicon = inputs.apple-silicon.overlays.apple-silicon-overlay;
  widevine = inputs.widevine.overlays.default;
  vscode-extensions = inputs.vscode-extensions.overlays.default;
}
