{
  description = "Olivia's Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    colmena.url = "github:zhaofengli/colmena";
    home-manager.url = "github:nix-community/home-manager";
    lanzaboote.url = "github:nix-community/lanzaboote";
    sops-nix.url = "github:Mic92/sops-nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # Regular nixpkgs overrides
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    colmena.inputs.stable.follows = "";
  };

  outputs =
    {
      self,
      nixpkgs,
      colmena,
      home-manager,
      treefmt-nix,
      ...
    }@inputs:
    let
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

      # https://github.com/zhaofengli/colmena/issues/60#issuecomment-2585780016
      mkColmenaHive =
        nixpkgs: nodeDeployments:
        let
          confs = inputs.self.nixosConfigurations;
          colmenaConf = {
            meta = {
              inherit nixpkgs;
              nodeNixpkgs = builtins.mapAttrs (_name: value: value.pkgs) confs;
              nodeSpecialArgs = builtins.mapAttrs (_name: value: value._module.specialArgs) confs;
            };
          }
          // builtins.mapAttrs (nodeName: value: {
            imports = value._module.args.modules;
            deployment = nodeDeployments.${nodeName} or { };
          }) confs;
        in
        inputs.colmena.lib.makeHive colmenaConf;

      treefmtEval = forAllSystems (system: treefmt-nix.lib.evalModule pkgs.${system} ./treefmt.nix);
    in
    {
      packages = forAllSystems (system: import ./pkgs pkgs.${system});

      colmenaHive = mkColmenaHive pkgs.x86_64-linux {
        apteryx = { };
        athene = {
          allowLocalDeployment = true;
          targetHost = null;
        };
        strigidae = {
          targetHost = "auth.slug.gay";
        };
      };

      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);
      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
      nixosConfigurations = import ./nixos { inherit inputs outputs; };
      overlays = import ./overlays { inherit inputs; };
      templates = import ./templates { };

      devShells = forAllSystems (
        system:
        let
          pkgs' = pkgs.${system};
          colmena' = colmena.packages.${system}.colmena;
        in
        {
          default = pkgs'.mkShell {
            buildInputs = [ pkgs'.bashInteractive ];
            packages =
              (builtins.attrValues {
                inherit (pkgs')
                  age
                  just
                  nix-output-monitor
                  nvd
                  opentofu
                  sops
                  ;
              })
              ++ [ colmena' ];
          };
        }
      );
    };
}
