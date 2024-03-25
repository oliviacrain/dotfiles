{
  description = "Olivia's Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    apple-silicon.inputs.nixpkgs.follows = "nixpkgs";

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

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

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

      templates =
        let
          trivial = {
            path = ./templates/trivial;
            description = "Basic flake with tooling I use";
          };
          rust = {
            path = ./templates/rust;
            description = "Oxalica rust-overlay flake";
          };
        in
        {
          default = trivial;
          inherit trivial rust;
        };

      overlays = import ./overlays { inherit inputs; };

      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        apteryx = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./nixos/apteryx/configuration.nix ];
        };

        cardinalis = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./nixos/cardinalis/configuration.nix ];
        };

        corvus = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./nixos/corvus/configuration.nix ];
        };
      };
    };
}
