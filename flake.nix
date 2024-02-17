{
  description = "Olivia's Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
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
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs-unstable.legacyPackages.${system}.nixfmt-rfc-style);

      overlays = import ./overlays { inherit inputs; };

      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "olivia@corvus" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./home-manager/home.nix ];
        };
      };

      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        apteryx = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/apteryx/configuration.nix
            vscode-server.nixosModules.default
          ];
        };
        cardinalis = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./nixos/cardinalis/configuration.nix
            vscode-server.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.users.olivia = import ./home-manager/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
              };
            }
          ];
        };
      };
    };
}
