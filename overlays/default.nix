{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  apple-silicon = inputs.apple-silicon.overlays.apple-silicon-overlay;
  widevine = inputs.widevine.overlays.default;
  vscode-extensions = inputs.vscode-extensions.overlays.default;
}
