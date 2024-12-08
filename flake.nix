{
  description = "Olivia's Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-actual.url = "github:oddlama/nixpkgs/feat-actual-budget";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    lix = {
      url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/heads/main";
      flake = false;
    };

    lix-module = {
      url = "git+https://git.lix.systems/lix-project/nixos-module";
      inputs.lix.follows = "lix";
    };

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    apple-silicon.url = "github:oliverbestmann/nixos-apple-silicon?rev=31bed7b26776a19b63ccb243337028f627326f92";
    apple-silicon.inputs.nixpkgs.follows = "nixpkgs";

    widevine.url = "github:epetousis/nixos-aarch64-widevine";
    widevine.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # These stable nixpkgs inputs are only used for checks, we don't care about that.
    # We set to system nixpkgs because `follows = ""` is hacky, see https://github.com/NixOS/nix/issues/7807.
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
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
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          buildInputs = [pkgs.bashInteractive];
          packages = builtins.attrValues {
            inherit
              (pkgs)
              age
              just
              nix-output-monitor
              nvd
              sops
              ;
          };
        };
      }
    );

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    nixosConfigurations = import ./nixos {inherit inputs outputs;};
    overlays = import ./overlays {inherit inputs;};
    templates = import ./templates {};
  };
}
