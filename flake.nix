{
  description = "Olivia's Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
      flake = false;
    };

    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    apple-silicon.inputs.nixpkgs.follows = "nixpkgs";

    widevine.url = "github:epetousis/nixos-aarch64-widevine";
    widevine.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      vscode-server,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        import ./pkgs (
          import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }
        )
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (pkgs)
            just
            nix-output-monitor
            bashInteractive
            mkShell
            ;
        in
        {
          default = mkShell {
            buildInputs = [ bashInteractive ];
            packages = [
              just
              nix-output-monitor
            ];
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      nixosConfigurations = import ./nixos { inherit inputs outputs; };
      overlays = import ./overlays { inherit inputs; };
      templates = import ./templates { };
    };
}
