{
  lib,
  requireFile,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "berkeley-mono";
  version = "1.009";

  # Standard ligatures, dotted zero, non-dashed seven
  src = requireFile {
    name = "berkeley-mono-typeface.zip";
    url = "https://berkeleygraphics.com/typefaces/berkeley-mono/";
    sha256 = "1k3b7x69gnkcsff0y6iy647gf7ir6pprka9qmvk4bawy2h5mvhv1";
  };

  sourceRoot = "berkeley-mono-variable";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/berkeley-mono TTF/*.ttf

    runHook postInstall
  '';

  meta = {
    homepage = "https://berkeleygraphics.com/typefaces/berkeley-mono/";
    license = lib.licenses.unfree;
  };
}
