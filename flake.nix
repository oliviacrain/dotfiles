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

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

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
    treefmt-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgs = forAllSystems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );

    treefmtEval = forAllSystems (system: treefmt-nix.lib.evalModule pkgs.${system} ./treefmt.nix);
  in {
    packages = forAllSystems (
      system: import ./pkgs pkgs.${system}
    );

    formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);
    checks = forAllSystems (system: {formatting = treefmtEval.${system}.config.build.check self;});
    nixosConfigurations = import ./nixos {inherit inputs outputs;};
    overlays = import ./overlays {inherit inputs;};
    templates = import ./templates {};

    devShells = forAllSystems (
      system: let
        pkgs' = pkgs.${system};
      in {
        default = pkgs'.mkShell {
          buildInputs = [pkgs'.bashInteractive];
          packages = builtins.attrValues {
            inherit
              (pkgs')
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
  };
}
