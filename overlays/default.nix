{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    tpm2-pkcs11 = prev.tpm2-pkcs11.override {fapiSupport = false;};
  };

  apple-silicon = inputs.apple-silicon.overlays.apple-silicon-overlay;
  widevine = inputs.widevine.overlays.default;
  vscode-extensions = inputs.vscode-extensions.overlays.default;
  lix-module = inputs.lix-module.overlays.default;
  actual-budget = final: prev: {
    inherit (inputs.nixpkgs-actual.legacyPackages.${prev.system}) actual-server;
  };
}
