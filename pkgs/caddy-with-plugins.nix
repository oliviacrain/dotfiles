# https://github.com/NixOS/nixpkgs/blob/a33b02fa9d664f31dadc8a874eb1a5dbaa9f4ecf/pkgs/servers/caddy/default.nix
{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gnused,
  nixosTests,
  caddy,
  testers,
  installShellFiles,
  externalPlugins ? [],
  vendorHash ? "sha256-ebnSehuhbCY58ctM8IRVMfNxxbJBp6ht9cbuLdGFNek=",
}: let
  attrsToModules = attrs:
    builtins.map
    (
      {
        name,
        repo,
        version,
      }: "${repo}"
    )
    attrs;
  attrsToSources = attrs:
    builtins.map
    (
      {
        name,
        repo,
        version,
      }: "${repo}@${version}"
    )
    attrs;
in
  buildGoModule rec {
    pname = "caddy";
    version = "2.8.4";

    dist = fetchFromGitHub {
      owner = "caddyserver";
      repo = "dist";
      rev = "v${version}";
      hash = lib.fakeHash;
      };

    src = fetchFromGitHub {
      owner = "caddyserver";
      repo = "caddy";
      rev = "v${version}";
      hash = lib.fakeHash;
    };

    inherit vendorHash;

    subPackages = ["cmd/caddy"];

    ldflags = [
      "-s"
      "-w"
      "-X github.com/caddyserver/caddy/v2.CustomVersion=${version}"
    ];

    nativeBuildInputs = [
      gnused
      installShellFiles
    ];

    modBuildPhase = ''
      for module in ${builtins.toString (attrsToModules externalPlugins)}; do
        sed -i "/standard/a _ \"$module\"" ./cmd/caddy/main.go
      done
      for plugin in ${builtins.toString (attrsToSources externalPlugins)}; do
        go get $plugin
      done

      go generate
      go mod vendor
    '';

    modInstallPhase = ''
      mv -t vendor go.mod go.sum
      cp -r --reflink=auto vendor "$out"
    '';

    preBuild = ''
      chmod -R u+w vendor
      [ -f vendor/go.mod ] && mv -t . vendor/go.{mod,sum}
      go generate

      for module in ${builtins.toString (attrsToModules externalPlugins)}; do
        sed -i "/standard/a _ \"$module\"" ./cmd/caddy/main.go
      done
    '';

    postInstall = ''
      install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

      substituteInPlace $out/lib/systemd/system/caddy.service --replace "/usr/bin/caddy" "$out/bin/caddy"
      substituteInPlace $out/lib/systemd/system/caddy-api.service --replace "/usr/bin/caddy" "$out/bin/caddy"

      $out/bin/caddy manpage --directory manpages
      installManPage manpages/*

      installShellCompletion --cmd caddy \
        --bash <($out/bin/caddy completion bash) \
        --fish <($out/bin/caddy completion fish) \
        --zsh <($out/bin/caddy completion zsh)
    '';

    passthru.tests = {
      inherit (nixosTests) caddy;
      version = testers.testVersion {
        command = "${caddy}/bin/caddy version";
        package = caddy;
      };
    };

    meta = with lib; {
      homepage = "https://caddyserver.com";
      description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
      license = licenses.asl20;
      mainProgram = "caddy";
      maintainers = [];
    };
  }
