{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    tpm2-pkcs11 = prev.tpm2-pkcs11.override { fapiSupport = false; };
  };

  colmena = inputs.colmena.overlays.default;
}
