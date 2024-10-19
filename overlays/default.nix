{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  modifications = final: prev: {
    calibre = prev.calibre.overrideAttrs {
      version = "7.20.0";
      src = final.fetchurl {
        url = "https://download.calibre-ebook.com/7.20.0/calibre-7.20.0.tar.xz";
        hash = "sha256-BhJEJsQKk/kJxycm/1mbtlrSaeFQPvWGGB9DUMidgII=";
      };
      buildInputs = prev.calibre.buildInputs ++ [final.ffmpeg];
      patches = [
        #  allow for plugin update check, but no calibre version check
        (final.fetchpatch {
          name = "0001-only-plugin-update.patch";
          url = "https://raw.githubusercontent.com/debian-calibre/calibre/debian/7.20.0+ds-1/debian/patches/0001-only-plugin-update.patch";
          hash = "sha256-mHZkUoVcoVi9XBOSvM5jyvpOTCcM91g9+Pa/lY6L5p8=";
        })
        (final.fetchpatch {
          name = "0007-Hardening-Qt-code.patch";
          url = "https://raw.githubusercontent.com/debian-calibre/calibre/debian/7.20.0+ds-1/debian/patches/hardening/0007-Hardening-Qt-code.patch";
          hash = "sha256-8tOxFCmZal+JxOz6LeuUr+TgX7IaxC9Ow73bMgFJPt8=";
        })
      ] ++ ["${inputs.nixpkgs}/pkgs/applications/misc/calibre/dont_build_unrar_plugin.patch"];
      installCheckPhase = ''
        runHook preInstallCheck

        ETN='--exclude-test-name'
        EXCLUDED_FLAGS=(
          $ETN 'test_7z'  # we don't include 7z support
          $ETN 'test_zstd'  # we don't include zstd support
          $ETN 'test_qt'  # we don't include svg or webp support
          $ETN 'test_import_of_all_python_modules'  # explores actual file paths, gets confused
          $ETN 'test_websocket_basic'  # flakey
          $ETN 'test_piper' # ???????
          $ETN 'test_unrar'
        )

        python setup.py test ''${EXCLUDED_FLAGS[@]}

        runHook postInstallCheck
      '';
    };
  };

  apple-silicon = inputs.apple-silicon.overlays.apple-silicon-overlay;
  widevine = inputs.widevine.overlays.default;
  vscode-extensions = inputs.vscode-extensions.overlays.default;
  lix-module = inputs.lix-module.overlays.default;
  actual-budget = final: prev: {
    inherit (inputs.nixpkgs-actual.legacyPackages.${prev.system}) actual-server;
  };
}
