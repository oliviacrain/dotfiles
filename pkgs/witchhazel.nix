{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "witchhazel";
  version = "0-unstable-2024-01-26";

  src = fetchFromGitHub {
    owner = "theacodes";
    repo = "witchhazel";
    rev = "5f4d7d76f0ece83ca1cb8791a852a3e8dc32f728";
    hash = "sha256-k95ZA/6mCqXmEmYfqHg1HRXxCrHo/eO68PBurEq11RA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/helix $out/alacritty
    install -m644 helix/*.toml $out/helix/
    install -m644 alacritty/*.toml $out/alacritty/

    runHook postInstall
  '';

  meta = {
    homepage = "https://witchhazel.thea.codes/";
    license = lib.licenses.asl20;
  };
}
