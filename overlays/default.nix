{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    tpm2-pkcs11 = prev.tpm2-pkcs11.override {fapiSupport = false;};
  };

  vscode-extensions = inputs.vscode-extensions.overlays.default;
  lix-module = inputs.lix-module.overlays.default;
}
